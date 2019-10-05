FROM python:3.7

LABEL "com.github.actions.name"="Deploy Python Function to AWS Lambda"
LABEL "com.github.actions.description"="Deploy python code to AWS Lambda with dependencies in a separate layer."
LABEL "com.github.actions.icon"="layers"
LABEL "com.github.actions.color"="yellow"

RUN apt-get update
RUN apt-get install -y jq zip tree
RUN pip install awscli

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
