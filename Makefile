.PHONY: build

BIN := demo.bin

build:
	go mod download
	go build -o ${BIN} -ldflags="-X 'main.version=${VERSION}'"

run:
	./${BIN}
