| toExport repository packageNames environment repositoryReference |

Transcript nextPutAll: '[Hermes] - Loading BaselineOfPharoBootstrap'; cr.

repositoryReference := (Smalltalk os environment at: 'BOOTSTRAP_REPOSITORY' ifAbsent: ['.']) asFileReference / 'src'.

repository := TonelRepository new
	directory: repositoryReference;
	yourself.
(repository versionWithInfo: (repository versionInfoFromVersionNamed: 'BaselineOfPharoBootstrap')) snapshot install.
(repository versionWithInfo: (repository versionInfoFromVersionNamed: 'BaselineOfTraits')) snapshot install.

Transcript nextPutAll: '[Hermes] - Generating Environment from repository'; cr.

toExport := #BaselineOfPharoBootstrap asClass sUnitPackageNames.
	
packageNames := #BaselineOfPharoBootstrap asClass kernelPackageNames, #BaselineOfTraits asClass allPackageNames, toExport.
environment := repository asRing2EnvironmentWith: packageNames.		

environment fixProtoObjectClassSuperclass.
environment addGlobalsNamed: #(Undeclared Smalltalk UTF8TextConverter MacRomanTextConverter FileStream ChangeSet Character Processor).

environment clean.

toExport do: [ :packageName |
	| oldPackage hePackage writer |
	oldPackage := environment ask packageNamed: packageName.
	hePackage := HERing2ToHermesBuilder new visitPackage: (oldPackage).
	writer := HEBinaryReaderWriter new
			stream: (File openForWriteFileNamed: ((Smalltalk os environment at: 'BOOTSTRAP_CACHE' ifAbsent: ['bootstrap-cache']) asFileReference / packageName, 'hermes') fullName);
			yourself.
	hePackage writeInto: writer.
	writer flush.
	writer close. ].

Transcript nextPutAll: '[Hermes] - Done'; cr.
