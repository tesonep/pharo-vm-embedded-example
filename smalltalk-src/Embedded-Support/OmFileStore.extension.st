Extension { #name : #OmFileStore }

{ #category : #'*Embedded-Support' }
OmFileStore >> flushEntryBuffer [

	self critical: [
		| initialPosition initialLocalName fileStream |
		self entryBuffer isEmpty ifTrue: [ ^self ].
				
		[ fileStream := ZnCharacterWriteStream on: fileReference binaryWriteStream encoding: #utf8. ] on: ReadOnlyFileException do: [ :anException |
			fileStream ifNotNil: [ fileStream close ].
			^ self
		 ].	
	
		[ | anEntryWriter |
			fileStream setToEnd.
			
			initialPosition := fileStream position.
			initialLocalName := self entryBuffer first value.
			anEntryWriter := self newEntryWriter.

			[ self entryBuffer isEmpty ] whileFalse: [
				| next entry |
				next := self entryBuffer removeFirst.
				entry := next key.

				"Write entry to file"
				anEntryWriter
					on: fileStream
					nextEntryPut: entry.
				].

			"In Linux it was necessary to explicitly flush the file stream"
			fileStream flush.
			
			lastStreamPosition := fileStream position.
			] ensure: [ fileStream close ].
	
		self refreshEntryPositionsByLocalNameStartingAt: initialPosition since: initialLocalName ].

]
