# PRD & Implementation Planner

Given the following feature or change description:

<feature_or_change_description>
$ARGUMENTS
</feature_or_change_description>

Generate an actionable Product Requirements Document (PRD) and implementation plan by following these principles:

1. Interpretation: Clearly understand the intent and goals of $ARGUMENTS.
2. Contextualization: Extract and synthesize relevant information from the existing codebase and documentation related to $ARGUMENTS to ensure planning is well-informed.
3. Iterative Clarification: Proactively identify and resolve ambiguities or missing information in $ARGUMENTS through concise, targeted questions to the user.
4. Structured Documentation: Produce a comprehensive PRD for $ARGUMENTS, organized into standardized sections (such as Overview, Requirements, User Stories, Technical Design, Acceptance Criteria, Tasks, and Testing Strategy).
5. Actionable Planning: Develop a prioritized breakdown of implementation tasks for $ARGUMENTS, highlighting key technical considerations, dependencies, and validation steps.
6. User Engagement: Involve the user at key stages for input and confirmation, adapting the process as needed to ensure clarity and completeness.
7. Deliver the final PRD as a markdown document in the ai_specs/ directory using the name ai_specs/$ARGUMENTS.md, along with a clear, task-oriented implementation plan ready for use by development teams.
8. DO NOT TRY TO IMPLEMENT THE FEATURE.

Begin by analyzing $ARGUMENTS and gathering initial codebase context relevant to it. If additional clarification is needed, ask targeted questions before proceeding.

UNDER NO CIRCUMSTANCES should you attempt to implement the feature or change described in $ARGUMENTS. Your role is strictly to plan and document the requirements and implementation strategy.
