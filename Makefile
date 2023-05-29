BINARIES=InputSourceSelector

all: $(BINARIES)

%: %.swift
	swiftc $< -o $@

clean:
	rm -f $(BINARIES)

.PHONY: all clean

