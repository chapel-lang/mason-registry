
use TOML;
use FileSystem;

proc findBricks() {
  here.chdir(parentDir+ '/Bricks/');
  const bricks = listdir();
  for brick in bricks {
    openTomls(brick);
  }
}

proc openTomls(brick : string) {
  here.chdir(brick);
  const versions = listdir();
  for file in versions {
    var tomlVersion = open(file, iomode.r);
    var toml = new owned(parseToml(tomlVersion));
    checkFormat(brick, toml);
    tomlVersion.close();
  }
}

proc checkFormat(brick : string, tomlFile) {
  var brickHeader = tomlFile['brick'].s;
  var brickName =  tomlFile['brick']['name'].s;
  var brickVersion = tomlFile['brick']['version'].s;
}

findBricks();