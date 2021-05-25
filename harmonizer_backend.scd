s.reboot;


//////////////////////////////////// MODEL ///////////////////////////////////////////////////

(

// This synth tracks the note sung by the user and sends it to the GUI
SynthDef.new(\voiceTracker, {
    |
    outputBus, network
    |
    var in, amp, freq, hasFreq;
    var midinum;
    in = Mix.new(SoundIn.ar([0,1]));
    amp = Amplitude.kr(in, 0.05, 1);
    # freq, hasFreq = Pitch.kr(in);
    midinum = freq.cpsmidi.round(1);
    freq = Lag.kr(midinum.midicps, 0.05);
    //sends the played note to the UI
    network.sendMsg('/playedNote', midinum);
    Out.ar(outputBus, in);
}).send(s);

// the synth which computes the harmonizations:
SynthDef.new(\harmonizer,{
    |
    inputBus,
    fundamental, harmonic1, harmonic2, harmonic3,
    voiceOutBus, harmonicsOutBus, gain = 0
    |
    var in = In.ar(inputBus, 0);
    var partials, voice, harmonics;
    var shift1, shift2, shift3;
     // the shift quantities used to compute the new pitch shifted harmonies
    shift1 = (fundamental - harmonic1).midiratio.reciprocal;
    shift2 = (fundamental - harmonic2).midiratio.reciprocal;
    shift3 = (fundamental - harmonic3).midiratio.reciprocal;

    partials = [
           0.5*shift1,
           1*shift1,
         0.5*shift2,
           1*shift2,
         0.5*shift3,
           1*shift3,
    ];
    //split two cases: main voice (uneffected and harmonies)
    voice = PitchShift.ar(in, 0.2, [0.5, 1], 0, 0.004);
    harmonics = gain*PitchShift.ar(in, 0.2, partials, 0, 0.004);
    Out.ar(voiceOutBus, voice);
    Out.ar(harmonicsOutBus, harmonics);
}).send(s);

 // this synth applies the given panning to the harmonics
SynthDef.new(\panning, {
    |
    pan, inputBus, outputBus
    |
    var input = In.ar(inputBus, 6);
    var mix, out;
    // pan each different track
    input[1] = Pan2.ar(input[1], pan*1);
    input[2] = Pan2.ar(input[2], pan*0.6);
    input[3] = Pan2.ar(input[3], pan*0.2);
    input[4] = Pan2.ar(input[4], pan*(-1));
    input[5] = Pan2.ar(input[5], pan*(-0.6));
    input[6] = Pan2.ar(input[6], pan*(-0.2));
     mix = Mix.new(input);
    out = Out.ar(outputBus, mix);
}).send(s);

 //final summing synth
SynthDef.new(\finalSum, {
    |
    inputBus, numVoices = 8
    |
	var input = In.ar(inputBus, 1);
    var out;
    7.do({
        out = AllpassN.ar(input, 0.040, [0.040.rand,0.040.rand], 2)
    });
    Out.ar(0,out/numVoices)
}).send(s);

)

////////////////////////////////// EFFECTS /////////////////////////////////////////////////////

(
SynthDef.new(\flangerEffect, {
    |
    rate = 1, maxDelay = 0.01, minDelay = 0.001, decayTime = 1, amp = 1, wetF = 0,
    inputBus, outputBus
    |
    var source = In.ar(inputBus,1);
    var flanged = CombC.ar(source, maxDelay, SinOsc.ar(rate, 0, (maxDelay * 0.5) - minDelay, (maxDelay * 0.5) + minDelay), decayTime, amp);
    var mixFlanged;
    mixFlanged = source*(1-wetF) + flanged*wetF;
    Out.ar(outputBus, mixFlanged);
}).send(s);

SynthDef.new(\chorusEffect, {
    |
    rate = 1, maxDelay = 0.05, minDelay = 0.01, wetC = 0,
    inputBus, outputBus
    |
    var num = 8;
    var source = In.ar(inputBus,1);
    var mixChorused;
    var input = source * num.reciprocal;
    var lfos = Array.fill(num, {SinOsc.ar(rate * rrand(0.95, 1.05), rrand(0.0, 1.0), (maxDelay * 0.5) - minDelay,  (maxDelay * 0.5) + minDelay)});
    var voices = DelayC.ar(input, maxDelay, lfos);
    voices = Mix.ar(voices);
    mixChorused = ((1-wetC)*input) + (wetC*voices);
    Out.ar(outputBus, mixChorused);
}).send(s);

SynthDef.new(\phaserEffect, {
    |
    inputBus, outputBus, wetP = 0, freq=0.2
    |
    var source = In.ar(inputBus,1); //get two channels of input starting (and ending) on bus 0
    var phased = AllpassN.ar(source,0.02,SinOsc.kr(freq,0,0.01,0.01)); //max delay of 20msec
    var mixPhased;
     mixPhased = source*(1-wetP) + phased*wetP;
    Out.ar(outputBus, mixPhased); //adds to bus 0 where original signal is already playing
}).send(s);

SynthDef.new(\reverbEffect, {
    |
    inputBus, outputBus, wetR = 0
    |
    // play with the room size
    var source = In.ar(inputBus,1);
    var reverb = GVerb.ar(source, 105, 5, 0.7, 0.8, 60, 0.1, 0.5, 0.4);
    var mixReverbed;
    mixReverbed = reverb*wetR + source*(1-wetR);
    Out.ar(outputBus, mixReverbed);
}).send(s);

SynthDef.new(\delayEffect, {
    |
    inputBus, outputBus, wetD = 0
    |
    var add;
    var source = In.ar(inputBus,1);
    var delay = DelayL.ar(source, 0.3, MouseX.kr(0,0.3), 1, add = 0.0);
    var mixDelayed;

    mixDelayed = delay*wetD + source*(1-wetD);
    Out.ar(outputBus, mixDelayed);
}).send(s);

SynthDef.new(\saturationEffect, {
    |
    inputBus, outputBus, wetS = 0
    |
    var source = In.ar(inputBus,1);
    var mixSaturated;

    source = source.softclip * 0.2;
    mixSaturated = source*wetS + source*(1-wetS);
    Out.ar(outputBus, mixSaturated);
}).send(s);

)
/////////////////////////////////////// INIT /////////////////////////////////////////////////
(

// first element of the chain
~root;

~n = NetAddr("127.0.0.1", 47120);


// create the busses
~trackerOut = Bus.audio(s,1);
~harmonizerOut = Bus.audio(s, 6);
~finalBus = Bus.audio(s,1);

~flIn = Bus.audio(s,1);
~phIn = Bus.audio(s,1);
~chIn = Bus.audio(s,1);
~revIn = Bus.audio(s,1);
~dlIn = Bus.audio(s,1);
~satIn = Bus.audio(s,1);

// instances of the various model Synth
~harmonizer = Synth.new(\harmonizer, [\inputBus, ~trackerOut, \voiceOutBus, ~finalBus, \harmonicsOutBus, ~harmonizerOut]);
~panning = Synth.new(\panning, [\inputBus, ~harmonizerOut, \outputBus, ~chIn] );
~finalSum = Synth.new(\finalSum, [\inputBus, ~finalBus]);

// instances of the various effects
~ch = Synth.new(\chorusEffect, [\inputBus, ~chIn, \outputBus, ~flIn]);
~fl = Synth.new(\flangerEffect, [\inputBus, ~flIn,  \outputBus, ~phIn]);
~ph = Synth.new(\phaserEffect, [\inputBus, ~phIn, \outputBus, ~satIn]);
~sat = Synth.new(\saturationEffect, [\inputBus, ~satIn, \outputBus, ~revIn]);
~rev = Synth.new(\reverbEffect, [\inputBus, ~revIn, \outputBus, ~dlIn]);
~dl = Synth.new(\delayEffect, [\inputBus, ~dlIn, \outputBus, ~finalBus]);


)


//////////////////////////////////////////////// CONTROLLER //////////////////////////////////////////
(

//the functions called after a message is received
var harmonizerOnOff = {
	|msg|
	if (msg[1] == 1,
		{
			~root = Synth.new(\voiceTracker, [\outputBus, ~trackerOut, \network, ~n]);
		},
		{
		~root.free;
		}
	);
};

var setHarmonics = {
	|msg|
	~harmonizer.set(\harmonic1, msg[1], \harmonic2, msg[2], \harmonic3, msg[3]);
	msg.postln;
};

var setEffectsParameters = {
	|msg|
	~ch.set(\wetC, msg[1]);
	~fl.set(\wetF, msg[2]);
	~ph.set(\wetP, msg[3]);
	~sat.set(\wetS, msg[4]);
	~rev.set(\wetR, msg[5]);
	~dl.set(\wetD, msg[6]);

};

var setGain = {
	|msg|
	~harmonizer.set(\gain, msg[1]);

};
var setWidth = {
	|msg|
	~panning.set(\pan, msg[1]);
};

OSCdef('onOSCreceiver', harmonizerOnOff, "/onOff");
OSCdef('harmonicsOSCreceiver', setHarmonics, "/harmonics");
OSCdef('gainOSCreceiver', setGain, "/gain");
OSCdef('widthOSCreceiver', setWidth, "/width");
OSCdef('effectsParamOSCreceiver', setEffectsParameters, "/effects");

)
