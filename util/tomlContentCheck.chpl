use TOML;
use FileSystem;
use Spawn;

/* Finds all the bricks in the local mason-registry and calls openTomls for
   each one */
proc findBricks() {
  const brickPath = absPath(parentDir+ '/Bricks/');
  here.chdir(brickPath);
  const bricks = listdir();
  for brick in bricks {
    here.chdir(brickPath +'/' +  brick);
    openTomls(brick);
  }
}

/* For each brick passed, opens each versions toml file and parses for
 testing, then once it calls the tests, closes the reader*/
proc openTomls(brick : string) {
  const versions = listdir();
  for file in versions {
    var tomlVersion = open(file, iomode.r);
    var toml = new owned(parseToml(tomlVersion));
    checkFormat(brick, toml);
    tomlVersion.close();
  }
}

/* Checks to make sure each field exists then calls checkSource to make
 sure the source field links to a valid repo */
proc checkFormat(brick : string, tomlFile) {
  var brickName =  tomlFile['brick']['name'].s;
  var brickVersion = tomlFile['brick']['version'].s;
  var brickChpl = tomlFile['brick']['chplVersion'].s;
  var brickSource = tomlFile['brick']['source'].s;

  assert(brickName == brick, "brick name does not match package name");
  assert(!brickVersion.isEmpty(), "brick version in " + brick + " is empty");
  assert(!brickChpl.isEmpty(), brick + " has no chapel Version listed");

  var source = checkSource(brickSource);
  assert(source.exit_status == 0, brick + "'s source is not a valid git repo.");
  writeln(brick + ' passed checks');
}

/* Opens a spawn call to see if the remote source is a valid repo,
 if not the call will exit with exit status casungo check Format
to fail */
proc checkSource(brickSource : string) {
  var remoteCommand = ('git ls-remote ' + brickSource).split();
  var remoteCheck = spawn(remoteCommand, stdout=PIPE);
  remoteCheck.wait();
  return remoteCheck;
}
findBricks();
