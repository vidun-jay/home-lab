FROM twingate/connector:1

ENV TWINGATE_NETWORK="kiwanis" \
    TWINGATE_LABEL_HOSTNAME="k8s-connector" \
    TWINGATE_LABEL_DEPLOYED_BY="kubernetes"

ENTRYPOINT ["/entrypoint.sh"]
