{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'cluster-state-alert.rules',
        rules: [
          {
            alert: 'CephClusterErrorState',
            expr: |||
              ceph_health_status{%(cephExporterSelector)s} > 1
            ||| % $._config,
            'for': $._config.clusterStateAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Storage cluster is in error state',
              description: 'Storage cluster is in error state for more than %s.' % $._config.clusterStateAlertTime,
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
          {
            alert: 'CephClusterWarningState',
            expr: |||
              ceph_health_status{%(cephExporterSelector)s} == 1
            ||| % $._config,
            'for': $._config.clusterStateAlertTime,
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: 'Storage cluster is in degraded state',
              description: 'Storage cluster is in warning state for more than %s.' % $._config.clusterStateAlertTime,
              storage_type: $._config.storageType,
              severity_level: 'warning',
            },
          },
          {
            alert: 'CephNodeDown',
            expr: |||
              ceph_node_down
            ||| % $._config,
            'for': $._config.cephNodeDownAlertTime,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Ceph Storage node {{ $labels.node }} went down',
              description: 'Ceph Storage node {{ $labels.node }} went down. Please check the node immeditely.',
              storage_type: $._config.storageType,
              severity_level: 'error',
            },
          },
        ],
      },
    ],
  },
}
