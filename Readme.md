# Hashlink 64-bit Typedef Function Argument Bug

This repo demonstrates an inconsistency between the 32-bit and 64-bit version builds of Hashlink in how they handle Dynamic objects being passed to a function with typedef'd argument. For example:

```haxe
public function receiveTypedef(obj:MyTypedef) {
  // Phantom fields are appearing in obj!
}
public function receiveDynamic(obj:Dynamic) {
  // Works fine every time
}
```

Confirmed to be reproducible as far back as HL 1.4 + Haxe 4.0.0 Preview 3, and is still reproducible as of HL 1.12 (SHA 06cce6d) + Haxe 4.2.4. Tested only on Windows 10 OS. The issue does not occur in any of the 32-bit Hashlink builds, whether compiled by hand or downloaded from the releases page. I was also unable to reproduce this issue without hscript in the mix (an attempt was made with `makeVarArgs()`), however it seems likely that the issue is not limited to hscript and has something to do with Reflect logic.

To run the test:

```bash
haxelib newrepo
haxelib install haxelib.json
haxe build.hxml
hl build.hl
```

Observe the following output in any 32-bit version of Hashlink:

```bash
------------Normal Method Call------------
Running receiveDynamic():
has field: chicken (9.25)
Running receiveTypedef():
has field: chicken (9.25)
------------Reflect.callMethod()------------
Running receiveDynamic():
has field: chicken (9.25)
Running receiveTypedef():
has field: chicken (9.25)
------------Reflect.callMethod() (via fcall())------------
Running receiveDynamic():
has field: chicken (9.25)
Running receiveTypedef():
has field: chicken (9.25)
------------Reflect.callMethod() (via makeVarArgs())------------
[{chicken : 9.25}]
Running receiveDynamic():
has field: chicken (9.25)
[{chicken : 9.25}]
Running receiveTypedef():
has field: chicken (9.25)
------------hscript------------
Running receiveDynamic():
has field: chicken (9.25)
Running receiveTypedef():
has field: chicken (9.25)
```


Observe the following output in any 64-bit version of Hashlink released since 1.4:

```bash
------------Normal Method Call------------
Running receiveDynamic():
has field: chicken (9.25)
Running receiveTypedef():
has field: chicken (9.25)
------------Reflect.callMethod()------------
Running receiveDynamic():
has field: chicken (9.25)
Running receiveTypedef():
has field: chicken (9.25)
------------Reflect.callMethod() (via fcall())------------
Running receiveDynamic():
has field: chicken (9.25)
Running receiveTypedef():
has field: chicken (9.25)
------------Reflect.callMethod() (via makeVarArgs())------------
Running receiveDynamic():
has field: chicken (9.25)
Running receiveTypedef():
has field: chicken (9.25)
------------hscript------------
Running receiveDynamic():
has field: chicken (9.25)
Running receiveTypedef():
has field: toPark (null)
has field: chicken (9.25)
```

The field `toPark` should not print in the hscript implementation as it was not specified in the script. We can see above it contains the value `null`, yet none of the other variations of the same code replicate the issue.

Note that changing the names of the typedef definition fields and adding/removing fields appears to affect the problem as well. In some cases the issue goes away, while in other cases a different phantom variable will appear.