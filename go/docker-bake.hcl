target "default" {
  output = [
    "type=registry,name=clanktron/scratchpad:dev",
    "type=docker,name=clanktron/scratchpad:dev"
  ]
}

target "all" {
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
