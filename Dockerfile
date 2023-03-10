FROM paholg/attic:latest

COPY actions_entrypoint.sh /actions_entrypoint.sh

ENTRYPOINT [ "/actions_entrypoint.sh" ]
