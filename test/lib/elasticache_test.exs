defmodule ExAws.ElastiCacheTest do
  use ExUnit.Case, async: true
  alias ExAws.ElastiCache
  alias ExAws.Operation.Query

  doctest ExAws.ElastiCache

  @version "2015-02-02"

  defp build_request(action, params \\ %{}) do
    action_param = action |> Atom.to_string |> Macro.camelize

    %Query{
      params: params |> Map.merge(%{"Version" => @version, "Action" => action_param}),
      path: "/",
      service: :elasticache,
      action: action
    }
  end

  test "create_cache_cluster no optional params" do
    expected = build_request(:create_cache_cluster,
      %{
        "CacheClusterId" => "TestCacheClusterId",
        "CacheNodeType" => "cache.t3.medium",
        "Engine" => "redis",
        "NumCacheNodes" => 3
      })

    assert expected == ElastiCache.create_cache_cluster("TestCacheClusterId", "cache.t3.medium", "redis", 3)
  end

  test "create_cache_cluster optional params" do
    expected = build_request(:create_cache_cluster,
      %{
        "CacheClusterId" => "TestCacheClusterId",
        "CacheNodeType" => "cache.t3.medium",
        "Engine" => "redis",
        "NumCacheNodes" => 3,
        "CacheSecurityGroupNames.CacheSecurityGroupName.1" => "default",
        "PreferredAvailabilityZones.PreferredAvailabilityZone.1" => "us-east-1a",
        "PreferredAvailabilityZones.PreferredAvailabilityZone.2" => "us-east-1b",
        "PreferredAvailabilityZones.PreferredAvailabilityZone.3" => "us-east-1c",
        "Port" => 8083
      })

    assert expected == ElastiCache.create_cache_cluster("TestCacheClusterId", "cache.t3.medium", "redis", 3,
      [cache_security_group_names: ["default"],
       preferred_availability_zones: ["us-east-1a", "us-east-1b", "us-east-1c"],
       port: 8083
      ])
  end

  test "create_replication_group no optional params" do
    expected = build_request(:create_replication_group,
      %{
        "ReplicationGroupId" => "myrepgroup",
        "ReplicationGroupDescription" => "My Rep Group"
      })

    assert expected == ElastiCache.create_replication_group("myrepgroup", "My Rep Group")
  end

  test "create_replication_group with optional params" do
    expected = build_request(:create_replication_group,
      %{
        "ReplicationGroupId" => "myrepgroup",
        "ReplicationGroupDescription" => "My Rep Group",
        "NodeGroupConfigurations.NodeGroupConfiguration.1.PrimaryAvailabilityZone" => "us-east-1a",
        "NodeGroupConfigurations.NodeGroupConfiguration.1.ReplicaAvailabilityZones.AvailabilityZone.1" => "us-east-1b",
        "NodeGroupConfigurations.NodeGroupConfiguration.1.ReplicaAvailabilityZones.AvailabilityZone.2" => "us-east-1c",
        "NodeGroupConfigurations.NodeGroupConfiguration.1.ReplicaCount" => 2,
        "NodeGroupConfigurations.NodeGroupConfiguration.1.Slots" => 0,
        "Tags.Tag.1.Key" => "Name",
        "Tags.Tag.1.Value" => "myrepgroup",
        "CacheNodeType" => "cache.t3.medium",
        "Engine" => "redis"
      })

    assert expected == ElastiCache.create_replication_group("myrepgroup", "My Rep Group",
      [ node_group_configurations: [{"us-east-1a", ["us-east-1b", "us-east-1c"], 2, 0}],
        tags: [ "Name": "myrepgroup" ],
        cache_node_type: "cache.t3.medium",
        engine: "redis"
      ])
  end

  test "create_replication_group with more optional params" do
    expected = build_request(:create_replication_group,
      %{
        "ReplicationGroupId" => "myrepgroup",
        "ReplicationGroupDescription" => "My Rep Group",
        "PreferredCacheClusterAZs.AvailabilityZone.1" => "us-east-1a",
        "PreferredCacheClusterAZs.AvailabilityZone.2" => "us-east-1b"
        })

    assert expected == ElastiCache.create_replication_group("myrepgroup", "My Rep Group",
        [preferred_cache_cluster_azs: ["us-east-1a", "us-east-1b"]])
  end

  test "delete_cache_cluster no optional params" do
    expected = build_request(:delete_cache_cluster,
      %{
        "CacheClusterId" => "TestCacheClusterId"
      })

    assert expected == ElastiCache.delete_cache_cluster("TestCacheClusterId")
  end

  test "delete_cache_cluster optional params" do
    expected = build_request(:delete_cache_cluster,
      %{
        "CacheClusterId" => "TestCacheClusterId",
        "FinalSnapshotIdentifier" => "SnapshotIdentifier"
      })

    assert expected == ElastiCache.delete_cache_cluster("TestCacheClusterId",
      [final_snapshot_identifier: "SnapshotIdentifier"])
  end

  test "describe_cache_clusters no optional params" do
    assert build_request(:describe_cache_clusters) == ElastiCache.describe_cache_clusters
  end

  test "describe_cache_clusters optional params" do
    expected = build_request(:describe_cache_clusters,
      %{
        "CacheClusterId" => "TestCacheClusterId",
        "MaxRecords" => 100,
        "ShowCacheNodeInfo" => true,
        "ShowCacheClustersNotInReplicationGroup" => true
      })

    assert expected == ElastiCache.describe_cache_clusters(
      [
        cache_cluster_id: "TestCacheClusterId",
        max_records: 100,
        show_cache_node_info: true,
        show_cache_clusters_not_in_replication_group: true
      ]
    )
  end

  test "delete_replication_group no optional params" do
    expected = build_request(:delete_replication_group,
      %{
        "ReplicationGroupId" => "MyRepGroup"
      })
    assert expected == ElastiCache.delete_replication_group("MyRepGroup")
  end

  test "delete_replication_group with optional params" do
    expected = build_request(:delete_replication_group,
      %{
        "ReplicationGroupId" => "MyRepGroup",
        "FinalSnapshotIdentifier" => "SnapshotIdentifier",
        "RetainPrimaryCluster" => false
      })

    assert expected == ElastiCache.delete_replication_group("MyRepGroup", [
      final_snapshot_identifier: "SnapshotIdentifier",
      retain_primary_cluster: false
      ])
  end

  test "describe_replication_groups no optional params" do
    assert build_request(:describe_replication_groups) == ElastiCache.describe_replication_groups
  end

  test "describe_replication_groups with optional params" do
    expected = build_request(:describe_replication_groups,
      %{
        "Marker" =>  "TestMarker",
        "MaxRecords" => 100,
        "ReplicationGroupId" => "TestReplicationGroup"
      })

    assert expected == ElastiCache.describe_replication_groups(
      [marker: "TestMarker", max_records: 100, replication_group_id: "TestReplicationGroup"]
    )
  end
end
