---
status: accepted
---

# Use Markdown Architectural Decision Records

## Context and Problem Statement

We want to record architectural decisions made in this project independent whether decisions concern the architecture ("architectural decision record"), the code, or other fields.
Which format and structure should these records follow?

## Decision Drivers

* Plain text and version-controllable format
* Lightweight and readable without specialized tooling
* Structured capturing of decision context, options, and rationale

## Considered Options

* [MADR](https://adr.github.io/madr/) – The Markdown Architectural Decision Records
* [Michael Nygard's template](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions) – The first incarnation of the term "ADR"
* [Sustainable Architectural Decisions](https://www.infoq.com/articles/sustainable-architectural-design-decisions) – The Y-Statements
* Formless – No conventions for file format and structure

## Decision Outcome

Chosen option: "MADR", because:

* Implicit assumptions should be made explicit. Design documentation is important to enable understanding decisions later on.
* MADR allows for structured capturing of any decision.
* The MADR format is lean and fits our development style.
* The MADR structure is comprehensible and facilitates usage & maintenance.

## Pros and Cons of the Options

### [MADR](https://adr.github.io/madr/)

* Good, because it provides a structured, lightweight markdown format easily read in IDEs and Git.
* Good, because it explicitly compares alternatives and captures decision drivers.
* Bad, because it requires ongoing discipline to document decisions as they occur.

### [Michael Nygard's template](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions)

* Good, because it established the baseline ADR pattern.
* Neutral, because it is narrative-heavy rather than option-comparison focused.
* Bad, because comparing multiple concrete alternatives side-by-side is less structured.

### [Sustainable Architectural Decisions](https://www.infoq.com/articles/sustainable-architectural-design-decisions)

* Good, because Y-statements provide crisp summaries.
* Bad, because full option exploration and trade-off comparisons are less prominent.

### Formless

* Good, because no upfront documentation effort is needed.
* Bad, because architectural context and rationale are lost over time.
