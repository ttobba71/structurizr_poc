# 2. Github Action Behavior

Date: 2022-10-26

## Status

Accepted

## Context

The autosync behavior provided with the structurizr/lite requires an additional properties file to exist in every repository documents folder.  The file contains sensitive information that we don't want to store in the repository.  This is a security concern.  Also, complicates each engineer's environment.  Also, it doesn't work properly when views aren't configured to use autoLayout.  

## Decision

Instead of using the default autosyncing behavior the structurizr/live container supports, we created a GitHub Action template that each repository will implement.  When code is merged into the mainline, the github action will upload the workspace.dsl file to the on-premise server.  This removes secret management overhead and solves the autoLayout limitation the on premise software contains.

## Consequences

The engineer has less to be concerned with after the Github Action is configured on repository.
