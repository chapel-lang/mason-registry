

==============
Mason-Registry
==============

The mason registry is a GitHub repository containing a list of versioned manifest files.

`Mason-Registry <https://github.com/chapel-lang/mason-registry>`_.

The registry structure is a hierarchy as follows:


.. code-block:: text

 registry/
   Curl/
      1.0.0.toml
      2.0.0.toml
   RecordParser/
      1.0.0.toml
      1.1.0.toml
      1.2.0.toml
   VisualDebug/
      2.2.0.toml
      2.2.1.toml


Each versioned manifest file is identical to the manifest file in the top-level directory
of the package repository, with one exception, a URL pointing to the repository and revision
in which the version is located.

The 'registry' ``0.1.0.toml`` would include the additional source field:

.. code-block:: text

     [brick]
     name = "hello_world"
     version = "0.1.0"
     author = ["Sam Partee <Sam@Partee.com>"]
     source = "https://github.com/Spartee/hello_world"

     [dependencies]
     curl = '1.0.0'





TOML
====

TOML is the configuation language chosen by the chapel developers for
configuring programs written in chapel using mason. A TOML file contains
the nessescary information to build a chapel program using mason. 
`TOML Spec <https://github.com/toml-lang/toml>`_.





Submit a package 
================

The mason registry will hold the manifest files for packages submitted by developers.
To contribute a package to the mason-registry a chapel developer will need to host their
project and submit a pull request to the mason-registry with the toml file pointing
to their project. For a more detailed description follow the steps below.

Steps:
      1) Write a library or binary project in chapel using mason
      2) Host that project in a git repository. (e.g. GitHub)
      3) Create a tag of your package that corresponds to the version number prefixed with a 'v'. (e.g. v0.1.0)
      4) Fork the mason-registry on GitHub
      5) Create a branch of the mason-registry and add your project's ``Mason.toml`` under ``Bricks/<project_name>/<version>.toml``
      6) Add a source field to your ``<version>.toml`` pointing to your project's repository.
      7) Open a PR in the mason-registry for your newly created branch containing just your <version>.toml.
      8) Wait for mason-registry gatekeepers to approve the PR.

Once your package is uploaded, maintain the integrity of your package, and please notify the
chapel team if your package should be taken down.


Namespacing
===========

All packages will exist in a single common namespace with a first-come, first-served policy.
It is easier to go to separate namespaces than to roll them back, so this position affords
flexibility.



Semantic Versioning
===================

To assist version resolution, the mason registry will enforce the following conventions:

The format for all versions will be a.b.c.
   Major versions are denoted by a.
   Minor versions are denoted by b.
   Bug fixes are denoted by c.

- If the major version is 0, no further conventions will be enforced.

- The major version must be advanced if and only if the update causes breaking API changes,
  such as updated data structures or removed methods and procedures. The minor and bug fix
  versions will be zeroed out. (ex. 1.13.1 -> 2.0.0)

- The minor version must be advanced if and only if the update adds functionality to the API
  while maintaining backward compatibility with the current major version. The bug fix 
  version will be zeroed out. (ex. 1.13.1 -> 1.14.0)

- The bug fix must be advanced for any update correcting functionality within a minor revision.
  (ex. 1.13.1 -> 1.13.2)

