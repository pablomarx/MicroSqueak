MicroSqueak
Copyright (c) John Maloney, 2010

MicroSqueak is a version of Squeak intended for use on an embedded processor
with a modest amount of CPU power and RAM of 100-200 kilobytes. An example
of such a processor is the Atmel AT91R40008, a 66 MHz ARM processor with
256 kbytes of RAM on the chip. The "micro" in MicroSqueak is a reference to
the fact that it's designed to run on a microprocessor. (It is really only one
order of magnitude smaller than ordinary Squeak, but "DeciSqueak" just doesn't
sound as cool as "MicroSqueak".)

There are more extensive notes in a workspace in MicroSqueakDev.image.
When I created this, the image run on all version of the Squeak virtual machine
from 2.8 to 3.2 or maybe 3.4. I'm not sure it if runs on the most modern
Squeak VM's since there have been some changes in the past few years.

Although I never got around to building an ARM virtual machine to run this,
I did get as far as generating a ~57k image that has all the Smalltalk-80
kernel classes (numbers, collections, etc.). There is a variant that can read
and write files and one that has support for Forms and Bitmap operations.
The image does not contain a compiler or any other way to load code, but
that should not be too difficult to add.

Recently, there has been renewed interest in small Squeak images, so I'm
making this available under the MIT license. It would be great to see a
small, extensible core Squeak image. Thanks to Eliot Miranda for encouraging
me to share this code, and for his contributions (below).

	-- John Maloney, October 2010


Notes from Eliot Miranda:

This is John Maloney's MicroSqueak, an image generator for Squeak V2.  An image contains the MObject hierarchy, which is a parallel subset of the Object hierarchy, and from this subset a new image is generated.  This differs crucially from cloning/stripping techniques such as SystemTracer in that it produces a new image from source with no historic artifacts, such as the state of pool dictionaries etc.

MicroSqueak.st is the image generator. MicroSqueak-colonequal.st is the same code but with := in place of _.

The various MSqueak-foo.st files are the MObject hierarchy.

MicroSqueakDev.image/.changes is a SqueakV2 image with the code loaded that successfully produces the 56k byte msqueak.image that, when run, writes 'Hello World' on log.txt.  You will need a Squeak 3.8 or earlier VM to run either MicroSqueakDev.image or msqueak.image.

StdioListener.cs is my own code that will read commands from standard in and print to standard out in a Squeak image with my stdio changes.  You'll need a VM with the relevant stdio spport (e.g. a Cog VM).

My desire is that we can
- define a headless core system that contains the compiler, good error reporting to standard out, the core collection and numeric libraries and file support;
- generate an image in the MicroSqueak style, generating it fresh from source
- use the resulting image to bootstrap a full Squeak image, first by filing-in Monticello and then by loading Monticello packages.

I assume the StdioListener will be useful in debugging the bootstrap process since it allows interactive headless development, reporting stack traces to standard out.  I know this can all be done with command-line doits and SqueakDebug.log but I prefer interactivity.

The rationale for taking a MicroSqueak-style approach is that doing so will
- produce a minimal image from which we can bootstrap any Squeak image;
- that this image can use whatever object representation a VM can profit from;
- that changing the object format will provide substantially better performance, including a 64-bit image format that includes SmallDouble.


Huge thanks to John Maloney for this code.
Eliot Miranda
October 2010
