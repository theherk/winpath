winpath
=======

winpath is just a small, simple tool to get Windows paths. It simply abstracts a few calls to the registry to return the current value of a few strings.

Installation
------------

    go get github.com/theherk/winpath

Usage
-----

``` go
import (
	"fmt"
	"github.com/theherk/winpath"
)

func main() {
	p, _ := winpath.AppData()
	fmt.Println(p)
}
```

### Testing

    make test

### Build for all architectures and systems.

    make clean all

Yep, that's it. Feel free to add any common paths to this library.
