target "default" {
  output = [
    "type=docker,name=clanktron/scratchpad:dev"
  ]
}

group "all" {
  targets = ["containers", "linux", "darwin", "windows"]
}

group "release-binaries" {
  targets = ["linux", "darwin", "windows"]
}

target "containers" {
  target = "production"
  platforms = [
    "linux/arm64",
    "linux/amd64",
    "linux/arm/v7",
    "linux/riscv64"
  ]
  output = [
    "type=registry,name=clanktron/scratchpad:dev",
  ]
}

target "linux" {
  target = "bin"
  matrix = {
    arch = ["arm64", "amd64", "arm", "riscv64"]
  }
  name = "linux-${arch}"
  args = {
    BINOS = "linux",
    BINARCH = "${arch}"
  }
  output = [
    "type=local,dest=./dist,platform-split=false",
  ]
}

target "darwin" {
  target = "bin"
  matrix = {
    arch = ["arm64", "amd64"]
  }
  name = "darwin-${arch}"
  args = {
    BINOS = "darwin",
    BINARCH = "${arch}"
  }
  output = [
    "type=local,dest=./dist,platform-split=false",
  ]
}

target "windows" {
  target = "bin"
  matrix = {
    arch = ["arm64", "amd64"]
  }
  name = "windows-${arch}"
  args = {
    BINOS = "windows",
    BINARCH = "${arch}"
  }
  output = [
    "type=local,dest=./dist,platform-split=false",
  ]
}
