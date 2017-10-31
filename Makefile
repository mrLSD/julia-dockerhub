run:
	@docker run -it --rm -v "$PWD":/usr/myapp -w /usr/myapp mrlsd/julia:0.6.1 julia script.jl

run-cli:
	@docker run --rm -it mrlsd/julia:0.6.1

build:
	@docker build -t mrlsd/julia:0.6.1 .
