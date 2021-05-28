s.reboot;


///////////////////////////////////// MODEL ////////////////////////////////////////////////////
(

// define a table of reference notes [c c# d ... b]
~table = Array.fill(12, {arg i; i + 60}); // [60,61,...,71]

// define a table of mapped notes (Default values)
~mapped = Array.fill(12, {arg i; i + 52}); // starts from e3
~mapped2 = Array.fill(12, {arg i; i + 55});
~mapped3 = Array.fill(12, {arg i; i + 59});

~midiON = 0;

// define a table to store the difference between reference and mapped note
~difference = Array.fill(~table.size, {0});
// define a buffer on the server for consultation from the SynthDef
~diffbuf = Buffer.loadCollection(s, ~table, action:{|msg| msg.postln;});

~difference2 = Array.fill(~table.size, {0});
~diffbuf2 = Buffer.loadCollection(s, ~table, action:{|msg| msg.postln;});
~difference3 = Array.fill(~table.size, {0});
~diffbuf3 = Buffer.loadCollection(s, ~table, action:{|msg| msg.postln;});

)

//////////////////////////////////// SYNTHS ///////////////////////////////////////////////////

(


SynthDef(\sampleNote, {
	|
	outputBus
	|
	var out, freq = 440;
	out = SinOsc.ar(freq, 1);
	Out.ar(outputBus, out)
}).send(s);



// This synth tracks the note sung by the user and sends it to the GUI
SynthDef.new(\voiceTracker, {
    |
    outputBus, outFreqBus
    |

    var in, amp, freq, hasFreq, out;
	var t, midinum;
	var harmony, harmony2, partials;

    in = Mix.new(SoundIn.ar([0,1]));

	amp = Amplitude.kr(in, 0.05, 1);
    # freq, hasFreq = Tartini.kr(in);

    Out.kr(outFreqBus, freq);
	Out.ar(outputBus, in);
}).send(s);

// the synth which computes the harmonizations with the use of buffers, modified by the GUI
SynthDef.new(\harmonizerGUI,{
    |
    inputBus, inFreqBus,
    voiceOutBus, harmonicsOutBus, gain = 0
    |

	var in = In.ar(inputBus, 1);
	var amp, freq, hasFreq;
	var partials, voice, harmonics;
    var shift1, shift2, shift3;
	var fundamental, inFreq;


	inFreq = In.kr(inFreqBus, 1);
	fundamental = inFreq.cpsmidi.round(1);

    // the shift quantities used to compute the new pitch shifted harmonies

	shift1 = WrapIndex.kr(~diffbuf.bufnum, fundamental);
	shift2 = WrapIndex.kr(~diffbuf2.bufnum, fundamental);
	shift3 = WrapIndex.kr(~diffbuf3.bufnum, fundamental);

    partials = [
           0.5*shift1,
           1*shift1,
         0.5*shift2,
           1*shift2,
         0.5*shift3,
           1*shift3,
    ];

    // split two cases: main voice (uneffected and harmonies)
	voice = Mix.new(PitchShift.ar(in, 0.2, [0.5, 1], 0, 0.004));
    harmonics = 2*gain * PitchShift.ar(in, 0.2, partials, 0, 0.004);

	Out.ar(voiceOutBus, voice);
	Out.ar(harmonicsOutBus, harmonics);
}).send(s);


// the synth which computes the harmonizations with the notes provided by the midi device
SynthDef.new(\harmonizerMIDI,{
    |
    inputBus, inFreqBus,
	harmonic1 = 64, harmonic2 = 67, harmonic3 = 71,
    voiceOutBus, harmonicsOutBus, gain = 0
    |

	var in = In.ar(inputBus, 1);
	var amp, freq, hasFreq;
	var partials, voice, harmonics;
    var shift1, shift2, shift3;
	var fundamental, inFreq;

	//in = In.ar(inputBus, 1)
	inFreq = In.kr(inFreqBus, 1);
	fundamental = inFreq.cpsmidi.round(1);

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

    // split two cases: main voice (uneffected and harmonies)
	voice = Mix.new(PitchShift.ar(in, 0.2, [0.5, 1], 0, 0.004));
    harmonics = 2*gain * PitchShift.ar(in, 0.2, partials, 0, 0.004);

	Out.ar(voiceOutBus, voice);
	Out.ar(harmonicsOutBus, harmonics);
}).send(s);



 // this synth applies the given panning to the harmonics
SynthDef.new(\panning, {
    |
    pan = 0.5, inputBus, outputBus
    |

    var input;
    var mix;

    // pan each different track
	input = In.ar(inputBus, 6);
	mix = Mix.new(Pan2.ar(input, pos: [0.6*pan, 0.2*pan, -1*pan, -0.6*pan, -0.2*pan]));

	Out.ar(outputBus, mix);
}).send(s);

 //final summing synth
SynthDef.new(\finalSum, {
    |
    inputBus, outputBus = 0, numVoices = 8
    |

	var input;
    var out;

	input = In.ar(inputBus, 1);

    7.do({
        out = AllpassN.ar(input, 0.040, [0.040.rand, 0.040.rand], 2)
    });

    Out.ar(outputBus, out);
}).send(s);

)

////////////////////////////////// EFFECTS /////////////////////////////////////////////////////
(

SynthDef.new(\chorusEffect, {
    |
    rate = 1, maxDelay = 0.05, minDelay = 0.01, wetC = 0,
    inputBus, outputBus
    |

    var num;
    var source;
    var mixChorused;
    var input;
    var lfos;
    var voices;

	num = 8;
	source = In.ar(inputBus, 1);
	input = source * num.reciprocal;
	lfos = Array.fill(num, {SinOsc.ar(rate * rrand(0.95, 1.05), rrand(0.0, 1.0), (maxDelay * 0.5) - minDelay,  (maxDelay * 0.5) + minDelay)});

	voices = Mix.ar(DelayC.ar(input, maxDelay, lfos));
    mixChorused = ((1 - wetC) * input) + (wetC * voices);

    Out.ar(outputBus, mixChorused);
}).send(s);


SynthDef.new(\flangerEffect, {
    |
    rate = 1, maxDelay = 0.01, minDelay = 0.001, decayTime = 1, amp = 1, wetF = 0,
    inputBus, outputBus
    |

    var source;
    var flanged;
    var mixFlanged;

	source = In.ar(inputBus, 1);
	flanged = CombC.ar(source, maxDelay, SinOsc.ar(rate, 0, (maxDelay * 0.5) - minDelay, (maxDelay * 0.5) + minDelay), decayTime, amp);
	mixFlanged = source * (1 - wetF) + (flanged * wetF);

    Out.ar(outputBus, mixFlanged);
}).send(s);


SynthDef.new(\phaserEffect, {
    |
    inputBus, outputBus, wetP = 0, freq = 0.2
    |

    var source;
    var phased;
    var mixPhased;

	source = In.ar(inputBus, 1); // get two channels of input starting (and ending) on bus 0
	phased = AllpassN.ar(source, 0.02, SinOsc.kr(freq, 0, 0.01, 0.01)); // max delay of 20msec
	mixPhased = source * (1 - wetP) + (phased * wetP);

    Out.ar(outputBus, mixPhased); // adds to bus 0 where original signal is already playing
}).send(s);


SynthDef.new(\saturationEffect, {
    |
    inputBus, outputBus, wetS = 0
    |

    var in, saturated;
    var mixSaturated;
	in = In.ar(inputBus, 1);

	saturated = in;
	saturated = saturated.distort;

	mixSaturated = in + saturated*wetS;
    Out.ar(outputBus, mixSaturated);
}).send(s);


SynthDef.new(\reverbEffect, {
    |
    inputBus, outputBus, wetR = 0
    |

    // room size
    var source;
    var reverb;
    var mixReverbed;

	source = In.ar(inputBus, 1);
	reverb = GVerb.ar(source, 105, 5, 0.7, 0.8, 60, 0.1, 0.5, 0.4);

	mixReverbed = (reverb * wetR) + source * (1 - wetR);
    Out.ar(outputBus, mixReverbed);
}).send(s);

SynthDef.new(\delayEffect, {
    |
    inputBus, outputBus, wetD = 0
    |

    var add;
    var source;
    var delay;
    var mixDelayed;

	source = In.ar(inputBus, 1);
	delay = DelayL.ar(source, 0.3, MouseX.kr(0,0.3), 1, add = 0.0);

	mixDelayed = (delay * wetD) + source * (1 - wetD);
    Out.ar(outputBus, mixDelayed);
}).send(s);


)
/////////////////////////////////////// INIT /////////////////////////////////////////////////
(

~root;
n = NetAddr("127.0.0.1", 57120);
b = NetAddr("127.0.0.1", 12000);

b.sendMsg("/superOn", 1);

// create the busses
~trackerOut = Bus.audio(s, 1);
~harmonizerOut = Bus.audio(s, 6);
~finalBus = Bus.audio(s, 1);

// this bus contains the frequency of the note sung by the user
~fundamentalBus = Bus.control(s, 1);

~chIn = Bus.audio(s, 1);
~flIn = Bus.audio(s, 1);
~phIn = Bus.audio(s, 1);
~satIn = Bus.audio(s, 1);
~revIn = Bus.audio(s, 1);
~dlIn = Bus.audio(s, 1);



// Create the groups
~inputGroup = Group.new;
~harmonizerGroup = Group.after(~inputGroup);
~panningGroup = Group.after(~harmonizerGroup);
~effectsGroup = Group.after(~panningGroup);
~outputGroup = Group.after(~effetcsGroup);

// instances of the various model Synth
~harmonizer = Synth.new(\harmonizerGUI, [\inputBus, ~trackerOut, \inFreqBus, ~fundamentalBus, \voiceOutBus, ~finalBus, \harmonicsOutBus, ~harmonizerOut], ~harmonizerGroup );
~panning = Synth.new(\panning, [\inputBus, ~harmonizerOut, \outputBus, ~chIn], ~panningGroup );


// instances of the various effects
~ch = Synth.after(~panning, \chorusEffect, [\inputBus, ~chIn, \outputBus, ~flIn], ~effectsGroup);
~fl = Synth.after(~ch,\flangerEffect, [\inputBus, ~flIn,  \outputBus, ~phIn], ~effectsGroup);
~ph = Synth.after(~fl, \phaserEffect, [\inputBus, ~phIn, \outputBus, ~satIn], ~effectsGroup);
~sat = Synth.after(~ph, \saturationEffect, [\inputBus, ~satIn, \outputBus, ~revIn], ~effectsGroup);
~rev = Synth.after(~sat, \reverbEffect, [\inputBus, ~revIn, \outputBus, ~dlIn], ~effectsGroup);
~dl = Synth.after(~rev, \delayEffect, [\inputBus, ~dlIn, \outputBus, ~finalBus], ~effectsGroup);

~finalSum = Synth.new(\finalSum, [\inputBus, ~finalBus], ~outputGroup);

//~x = Synth.before(~ch, \sampleNote, [\outputBus,~satIn ]);

)


//////////////////////////////////////////////// CONTROLLER //////////////////////////////////////////
(

//the functions called after a message is received
var harmonizerOnOff = {
	|msg|
	if (msg[1] == 1.0,
		{
			~root = Synth(\voiceTracker, [\outputBus,  ~trackerOut, \outFreqBus, ~fundamentalBus], ~inputGroup);
			~root.postln;
		},
		{
		~root.free;
		~root.postln;
		}
	);
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
	msg.postln;
};

var setGain = {
	|msg|
	~harmonizer.set(\gain, msg[1]);
	msg.postln;

};
var setWidth = {
	|msg|
	~panning.set(\pan, msg[1]);
	msg.postln;
};

var setNote = {
	|msg|
	if ( msg[1].asInteger == 1, {
		~mapped[msg[2].asInteger] = msg[3].asInteger;
    	 ~difference[msg[2]] = (~table[msg[2]] - ~mapped[msg[2]]).midiratio.reciprocal;
		 ~diffbuf.setn(0, ~difference);

	},
	{
		if( msg[1].asInteger == 2, {
			~mapped2[msg[2].asInteger] = msg[3].asInteger;
		    ~difference2[msg[2]] = (~table[msg[2]] - ~mapped2[msg[2]]).midiratio.reciprocal;
			~diffbuf2.setn(0, ~difference2);
		}
		,
		{
			~mapped3[msg[2].asInteger] = msg[3].asInteger;
			~difference3[msg[2]] = (~table[msg[2]] - ~mapped3[msg[2]]).midiratio.reciprocal;
			~diffbuf3.setn(0, ~difference3);
		});
	});

	//~mapped.do({arg item; item.postln});
	msg.postln;
};

var midiOnOff = {
	|msg|
	if (msg[1] == 1.0,
		{
			~midiOn = 1;
			~harmonizer.free;
			~harmonizer = Synth.new(\harmonizerMIDI, [\inputBus, ~trackerOut, \inFreqBus, ~fundamentalBus, \voiceOutBus, ~finalBus, \harmonicsOutBus, ~harmonizerOut],~harmonizerGroup);

		},
		{
			~midiOn = 0;
			~harmonizer.free;
			~harmonizer = Synth.new(\harmonizerGUI, [\inputBus, ~trackerOut, \inFreqBus, ~fundamentalBus, \voiceOutBus, ~finalBus, \harmonicsOutBus, ~harmonizerOut], ~harmonizerGroup);
		}
	);
	msg.postln;
};


var setMidiNotes = {
	|msg|
	msg.postln;
	if (~midiOn == 1,
		{
			~harmonizer.set(\harmonic1, msg[1].asInteger);
			~harmonizer.set(\harmonic2, msg[2].asInteger);
			~harmonizer.set(\harmonic3, msg[3].asInteger);
		}
	);
	msg.postln;
};

OSCdef('onOSCreceiver', harmonizerOnOff, "/onOff");
OSCdef('gainOSCreceiver', setGain, "/gain");
OSCdef('widthOSCreceiver', setWidth, "/width");
OSCdef('effectsParamOSCreceiver', setEffectsParameters, "/effects");
OSCdef('newNoteOSCreceiver', setNote, "/noteModify");
OSCdef('midiONOSCreceiver', midiOnOff, "/MIDIonOff");
OSCdef('midiNotesOSCreceiver', setMidiNotes, "/MIDInotes");

)

