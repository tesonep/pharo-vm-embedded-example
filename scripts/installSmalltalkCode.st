path := CommandLineArguments default commandLineArguments last.
Metacello new
  baseline: 'EmbeddedSupport';
	repository: 'gitlocal://' , path , '/smalltalk-srcsrc';
	load