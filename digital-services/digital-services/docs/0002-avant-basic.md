# 2. Avant Basic

Date: 2022-10-24

## Status

Accepted

## Context

Avant Basic represents the monolith system we're migrating from Amount.  

## Decision

All traffic is routed through the kong gateway to Avant services as well as Avant Basic.  This will help us incrementally strangle out functionality from Avant Basic as new services come online.

## Consequences

The deployed environment is somewhat more complex.  There's more routing which could increase latency.  
