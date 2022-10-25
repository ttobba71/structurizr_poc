# Readme.md

## How to use the CLI.
The Structurizr CLI is a command line interface application that supports the following behaviors.

- **********push********** content to the Structurizr cloud service or our on-premise installation.
- **********pull********** workspace content as JSON.
- **********lock********** a workspace to prevent edits.
- ************unlock************ a workspace to allow edits.
- **************export************** diagrams to PlanUML, Mermaid, WebSequenceDiagrams, DOT, and Ilograph; or a DSL workspace to JSON
- ********list******** elements within a workspace
- ****************validate**************** a JSON/DSL workspace definition

You can find CLI getting started information at [https://github.com/structurizr/cli/blob/master/docs/getting-started.md](https://github.com/structurizr/cli/blob/master/docs/getting-started.md).

Notes on CLI usage:

In order to push or pull from our on-premise solution, a workspace must be initialized. 

The following arguments are required for the CLI to work with our on-premise solution.

- ******-id****** (Each workspace has a unique id, this is the id of the workspace you wish to communicate within the on-premise solution)
- **-key** (The API key configured to access the workspace)
- **-secret** (The secret configured for accessing the workspace)
- ********************-workspace******************** (A path to the workspace files.  It should be a doc folder inside each source repository at Avant.)
- ********-url******** (The url to our on-premise solution)
- ************************-merge false************************ (-merge defaults to true.  We’re using GitHub for versioning, and we do not need versioning maintained in the on-premise solution)