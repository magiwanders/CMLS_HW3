s.boot;


(
// global variable containing the harmonizer
~sound;


n = NetAddr("127.0.0.1", 47120);



// the synth which computes the harmonizations:

SynthDef.new("harmonizer",{
	|
	harmonic1, harmonic2, harmonic3,
	voiceBus, harmonicsBus;
	|


    var in, amp, freq, hasFreq, out;
    var t, midinum;
    var partials;
    in = Mix.new(SoundIn.ar([0,1]));
    amp = Amplitude.kr(in, 0.05, 1);
    # freq, hasFreq = Pitch.kr(in);
    midinum = freq.cpsmidi.round(1);
    freq = Lag.kr(midinum.midicps, 0.05);
    // freq = midinum.midicps;

	n.send('/playedNote', midinum);

	// the shift quantities used to compute the new pitch shifted harmonies
	shift1 = (midinum - harmonic).midiratio.reciprocal;
	shift2 = (midinum - harmonic2).midiratio.reciprocal;
	shift3 = (midinum - harmonic3).midiratio.reciprocal;

    partials = [
           0.5*shift,
           1*shift,
         0.5*shift2,
           1*shift2,
		 0.5*shift3,
           1*shift3,
    ];

	//split two cases: main voice (uneffected and harmonies)
	voice = PitchShift.ar(in, 0.2, [0.5, 1], 0, 0.004);

	harmonics = PitchShift.ar(in, 0.2, partials, 0, 0.004);

	Out.ar(voiceBus, voice);
	Out.ar(harmonicsBus, harmonics);

}).send(s);

SynthDef.new(\panning, {
	|
	pan;
	|
	input = In.ar(hBus, 6);

	// pan each different track
	input[1] = Pan2.ar(input[1], pan*1);
	input[2] = Pan2.ar(input[2], pan*0.6);
	input[3] = Pan2.ar(input[3], pan*0.2);
	input[4] = Pan2.ar(input[4], -pan*1);
	input[5] = Pan2.ar(input[5], -pan*0.6);
	input[6] = Pan2.ar(input[6], -pan*0.2);
	mix = Mix.new(input);
	out = Out.ar(eBus, mix);

}).send(s);

SynthDef(\flangerEffect, {|rate = 1, maxDelay = 0.01, minDelay = 0.001, decayTime = 1, amp = 1, wet = 0|
	
	//var input = In.ar(in, 1);
	var source = input.ar(eBus,0);
	var flanged = CombC.ar(source, maxDelay, SinOsc.ar(rate, 0, (maxDelay * 0.5) - minDelay, (maxDelay * 0.5) + minDelay), decayTime, amp);
	wet = OSCreceiveblablabla[0,1];
	mixFlanged = source*(1-wet) + flanged*wet;
	Out.ar(finalBus, mixFlanged);
	
}).send(s);

SynthDef(\chorusEffect, {|in = 0, out = 0, rate = 1, maxDelay = 0.05, minDelay = 0.01, wet = 0, amp = 1|
	
	var output, num = 8;
	var source = input.ar(eBus,0);
	var input = source * num.reciprocal;
	var lfos = Array.fill(num, {SinOsc.ar(rate * rrand(0.95, 1.05), rrand(0.0, 1.0), (maxDelay * 0.5) - minDelay,  (maxDelay * 0.5) + minDelay)});
	var voices = DelayC.ar(input, maxDelay, lfos);
	voices = Mix.ar(voices);
	mixChorused = ((1-wet)*input) + (wet*voices);
	Out.ar(finalBus, mixChorused);

}).send(s);

(
SynthDef(\phasingEffect, {
	
	arg freq=0.2, wet = 0;
	var input, effect;
	var source = input.ar(eBus,0); //get two channels of input starting (and ending) on bus 0
	var phased = AllpassN.ar(input,0.02,SinOsc.kr(freq,0,0.01,0.01)); //max delay of 20msec
	mixPhased = source*(1-wet) + phased*wet;
	Out.ar(finalBus, mixPhased); //adds to bus 0 where original signal is already playing
	
}).send(s);
)

(
SynthDef(\reverbEffect, {
	
	arg wet = 0;
    // play with the room size
	var source = input.ar(eBus,0);
    var reverb = GVerb.ar(source, 105, 5, 0.7, 0.8, 60, 0.1, 0.5, 0.4);
	mixReverbed = reverb*wet + source*(1-wet);
	Out.ar(finalBus, mixReverbed);
	
}).send(s);
)

(
SynthDef(\delayEffect, {
	
	arg wet = 0;
	var source = input.ar(eBus,0);
	var delay = DelayL.ar(source, 0.3, MouseX.kr(0,0.3), 1, add = 0.0);
	mixDelayed = delay*wet + source*(1-wet);
	Out.ar(finalBus, mixDelayed);
	// input is mixed with delay via the add input
	
}).send(s);
)

fl = Synth.new(\flangerEffect);
ph = Synth.new(\phaserEffect);
ch = Synth.new(\chorusEffect);
rev = Synth.new(\reverbEffect);
dl = Synth.new(\delayEffect);

// VOCODER&DISTORSORE = ;

SynthDef.new(\effects, {
	|
	param1; //flanged
	param2;
	param3;
	param4;
	param5;
	|
	input.ar(eBus,0);
	
	out = Out.ar(finalBus, ...);
}).send(s);	
	

//final summing synth
SynthDef.new(\finalSum, {
	|
	finalBus, numVoices = 8;
	|

	input = In.ar(finalBus, 1);


    7.do({
        out = AllpassN.ar(input, 0.040, [0.040.rand,0.040.rand], 2)
    });

    Out.ar(0,out/numVoices)
}).send(s);


//declare the busses and initialize the synths
hBus = Bus.audio(s, 1);
finalBus = Bus.audio(s,1);
eBus = Bus.audio(s,1);

x = Synth.new(\finalSum, [\finalBus, finalBus]); // 
y = Synth.new(\panning);

//the functions called after a message is received
var harmonizerOnOff = {
	|msg|
	if (msg[1] == 1,
		{
			~sound = Synth.new(\harmonizer, [\voiceBus, finalBus, \harmonicsBus, hBus]);
		},
		{
		~sound.free;
		}
	);
};

var setHarmonics = {
	|msg|
	~sound.set(\harmonic, msg[1], \harmonic2, msg[2], \harmonic3, msg[3]);

};

var setEffectsParameters = {
	|msg|
	fl.set(\wetF, msg[1]);
	ph.set(\wetP, msg[2]);
	ch.set(\wetC, msg[3]);
	dl.set(\wetD, msg[4]);
	rev.set(\wetR, msg[5]);
	//vocoderEffect.set(\wetV, msg[6]);
	// DISTORSIONE
	
};

var setGain = {
	|msg|
	~sound.set(\gain, msg[1]);

};
var setWidth = {
	|msg|
	y.set(\pan, msg[1]);
};

OSCdef('onOSCreceiver', harmonizerOnOff, "/onOff");
OSCdef('harmonicsOSCreceiver', setHarmonics, "/harmonics");
OSCdef('gainOSCreceiver', setGain, "/gain");
OSCdef('widthOSCreceiver', setWidth, "/width");
OSCdef('effectsParamOSCreceiver', setEffectsParameters, "/effects");


)

