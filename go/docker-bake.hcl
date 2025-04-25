target "default" {
  output = [
    "type=registry,name=clanktron/scratchpad:dev",
    "type=docker,name=clanktron/scratchpad:dev"
  ]
}

group "all" {
  targets = ["containers", "linux", "darwin"]
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
  target = "darwin-bin"
  matrix = {
    arch = ["arm64", "amd64"]
  }
  name = "darwin-${arch}"
  args = {
    DARWIN_ARCH = "${arch}"
  }
  output = [
    "type=local,dest=./dist,platform-split=false",
  ]
}
