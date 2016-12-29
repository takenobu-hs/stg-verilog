
library tests
=============

a pattern
---------

### run pattern
```
$ cd pattern
$ make clean
$ make <PATTERN_NAME>.run
```

### view wave
```
$ cd pattern
$ make WAVE=YES basic.run
$ make wave
```

## clean
```
$ cd pattern
$ make clean
  or
$ make <PATTERN_NAME>.clean
```

### validation (test)
```
$ cd pattern
$ make clean
$ make <PATTERN_NAME>.test
```

### accept (register result)
```
$ cd pattern
$ make clean
$ make <PATTERN_NAME>.accept
```


all patterns on a directory
---------------------------

### run all patterns
```
$ cd pattern
$ make clean
$ make run
```

### validate all patterns
```
$ cd pattern
$ make clean
$ make all
```

### accept all patterns
```
$ cd pattern
$ make clean
$ make accept
```

