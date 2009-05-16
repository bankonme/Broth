Server.program = "/usr/bin/scsynth";

// same for Score
Score.program = Server.program;

// set some server options for different setups
#[\internal, \local].do { |s|
	s = Server.perform(s);
	s.options.numInputBusChannels = 2; // set the number of output jack ports
	s.options.numOutputBusChannels = 2; // set the number of input jack ports
	s.options.memSize = 1024 * 54; // 12 Mb for the synth, rt-memory for DelayC and friends
	s.options.maxNodes = 1024 * 4; // increase the maximum number of nodes to play simultaneously
};

// hook up jack ports to audio channels
"SC_JACK_DEFAULT_INPUTS".setenv(
	"system:capture_1,"
	"system:capture_2"
);
"SC_JACK_DEFAULT_OUTPUTS".setenv(
	"system:playback_1,"
	"system:playback_2"
);
 
//---- now set up our gui portion ----//
GUI.swing; //use swingosc

SwingOSC.program = "/usr/share/SwingOSC/SwingOSC.jar";

g = SwingOSC.default;

g.waitForBoot({
 	Server.local.makeGui; //show local server
 	Server.internal.makeGui; //show internal server
});

