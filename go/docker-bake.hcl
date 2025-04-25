target "default" {
  output = [
    "type=registry,name=clanktron/scratchpad:dev",
    "type=docker,name=clanktron/scratchpad:dev"
  ]
}

group "all" {
  targets = ["linux", "darwin"]
}

target "linux" {
  target = "output"
  platforms = [
    "linux/arm64",
    "linux/amd64",
    "linux/arm/v7",
    "linux/riscv64"
  ]
  output = [
    "type=local,dest=./dist,platform-split=false",
  ]
}

target "darwin" {
  matrix = {
    arch = ["arm64", "amd64"]
  }
  name = "darwin-${arch}"
  target = "darwin-output"
  args = {
    DARWIN_ARCH = "${arch}"
  }
  output = [
    "type=local,dest=./dist,platform-split=false",
  ]
}
