package main

import (
	"fmt"
	"os"
	"strconv"
	"syscall"
)

func main() {
	fmt.Println(os.Args[0])

	fmt.Println(strconv.FormatInt(int64(syscall.Getuid()), 10))

}
