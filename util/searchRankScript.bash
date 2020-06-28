#!/usr/bin/env bash
# Clone the package to be published from latest commit
package=$(git diff --name-only HEAD HEAD~1)
end=".end"

# check for TOML file
if [[ $package != *".toml"* ]]; then
  echo "Not TOML FILE"
  exit 0
fi
path="$package$end"
cd "$(dirname "$path")" || exit 1
FILE=$package
basename "$FILE"
f="$(basename -- "$FILE")"
source="$(grep source "$f"| cut -d= -f2)"
fixed=$(echo "$source" | tr -d '"')
name="$(grep name "$f" | cut -d= -f2 | tr -d '"' | tr -d ' ')"
version="$(grep version "$f" | cut -d= -f2 | tr -d '"' | tr -d ' ')"
git clone "$fixed" newPackage
cd newPackage || exit 1

# Perform a series of check on the package and award points
mason=./Mason.toml
testDir=./test/
exampleDir=./example/
srcDir=./src/
score=0
countForREADME=$(ls -l ./README.* 2>/dev/null | wc -l)
if [ "$countForREADME" != 0 ]
then
  echo "README found"
  score=$((score+1))
fi
countForModuleFile=$(ls -l ./src/*.chpl 2>/dev/null | wc -l)
if [ "$countForModuleFile" != 0 ]
then
  echo "ModuleFile found"
  score=$((score+1))
fi
[[ -f "$mason" ]] && score=$((score+1)) && echo "Mason.toml found"
[[ -d "$testDir" ]] && score=$((score+1)) && echo "test dir found"
[[ -d "$exampleDir" ]] && score=$((score+1)) && echo "example dir found"
[[ -d "$srcDir" ]] && score=$((score+1)) && echo "src dir found"

# points for number of examples 
countForExamples=$(ls -l ./example/*.chpl 2>/dev/null | wc -l)
score=$((score+countForExamples))

# points for number of tests
countForTests=$(ls -l ./test/*.chpl 2>/dev/null | wc -l)
score=$((score+countForTests))
echo "$score"

cd ../../../ || exit 1

# check if package name and version already exists 
if grep "$name.\"$version\"" cache.toml
then 
  echo "Package already exists. Cannot overwrite."
  exit 1
fi

# append package score to TOML cache file
echo "[$name.\"$version\"]" >> cache.toml
echo "score = $score" >> cache.toml
echo "Wrote $name=$score to cache.toml"

