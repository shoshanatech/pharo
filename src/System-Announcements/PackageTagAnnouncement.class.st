"
My classes represent package tags modifications in the system.
"
Class {
	#name : 'PackageTagAnnouncement',
	#superclass : 'SystemAnnouncement',
	#instVars : [
		'tag'
	],
	#category : 'System-Announcements-System-Packages',
	#package : 'System-Announcements',
	#tag : 'System-Packages'
}

{ #category : 'instance creation' }
PackageTagAnnouncement class >> in: aPackage tag: aSymbol [
	^self new
		package: aPackage;
		tag: aSymbol
]

{ #category : 'class initialization' }
PackageTagAnnouncement class >> initialize [

	self deprecatedAliases: { 'ClassTagAnnouncement' }
]

{ #category : 'instance creation' }
PackageTagAnnouncement class >> to: aPackageTag [

	^ self new
		  tag: aPackageTag;
		  yourself
]

{ #category : 'testing' }
PackageTagAnnouncement >> affectsPackage: aPackage [

	^ self package == aPackage
]

{ #category : 'testing' }
PackageTagAnnouncement >> affectsPackages [

	^ true
]

{ #category : 'accessing' }
PackageTagAnnouncement >> package [

	^ self tag package
]

{ #category : 'accessing' }
PackageTagAnnouncement >> packagesAffected [

	^ { self package }
]

{ #category : 'accessing' }
PackageTagAnnouncement >> tag [
	^ tag
]

{ #category : 'accessing' }
PackageTagAnnouncement >> tag: aPackageTag [
	tag := aPackageTag
]
