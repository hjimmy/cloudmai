# E2. Concurrent operations on 1,000 hosts

E2 是三组同一口径的实验，而不是一张扫描表加一句趋势说明。三组共用 1,000 台主机、四个平台和同一组列：吞吐（hosts/s）、P99（s）、送达率、最大并发等级。

| 组 | 表 | 每台主机上的动作 | 计入送达的条件 |
| --- | --- | --- | --- |
| 并发扫描 | Table 13 | 采集一份扫描报告 | 服务器接受完整报告 |
| 软件包下发 | Table 14 | 安装一个软件包 | 包数据库报出指定版本，且服务器接受回执 |
| 配置下发 | Table 15 | 写入一个配置单元 | 回读内容与目标一致，且服务器接受回执 |

Table 13 的数字来自已给出的测量。Table 14 和 Table 15 的测量格留在 `eval/e2/measurements.csv`：四个平台的吞吐、P99、送达率和并发等级都填上之后，`python3 eval/e2/e2_tables.py` 才会打出这两张表。下发实验的结果写在各自的表里。

平台顺序与表 13 一致：KMOMP、Satellite 6.14、Ansible AWX、SUSE Manager。并发等级只用 high、mid、low 这三个已有标签，并同时记下当时的配置扇出，避免把等级回写成连接数。

## Shared method

Each workload is one wave of 1,000 already enrolled hosts. Background sync and scheduled scans are quiesced so the wave is the only dispatch. Latency for a host starts when the server admits that host and stops when the success condition above is recorded. Throughput is the sustained completion rate in hosts per second. P99 is the 99th percentile of per-host latency. Delivery is verified successes divided by 1,000. Throughput and P99 are measured separately: the published scan P99 is longer than 1,000 divided by the published scan rate, which is what a pipelined wave looks like, so neither column is derived from the other.

The scan points below are the reported point estimates. Variance and repeat count were not part of that report. A new package or config run records its repeat count, payload size, and configured fan-out in the measurement sheet; those fields stay in the lab log and out of the five paper columns.

Actions go through each platform’s native scan, package, and configuration path. Hosts start without the dispatched package installed, and with configuration content different from the desired unit, so the write is observable. Package bytes and the config-unit size are controlled variables for Tables 14 and 15. The scan has no payload.

## Scan

On the scan workload (Table 13), KMOMP sustains 1,847 hosts/s with a P99 of 2.8 s and 99.99% delivery. Satellite 6.14 sustains 312 hosts/s (P99 12.0 s, delivery 99.8%). SUSE Manager sustains 276 hosts/s (P99 14.5 s, delivery 99.7%). Ansible AWX sustains 89 hosts/s (P99 45.0 s, delivery 99.5%). Stable concurrency is high for KMOMP, mid for Satellite 6.14 and SUSE Manager, and low for Ansible AWX.

Table 13. Concurrent scan throughput (1,000 hosts).

| Platform | Throughput (hosts/s) | P99 (s) | Delivery | Max concurrency |
| --- | ---: | ---: | ---: | --- |
| KMOMP | 1847 | 2.8 | 99.99% | high |
| Satellite 6.14 | 312 | 12.0 | 99.8% | mid |
| Ansible AWX | 89 | 45.0 | 99.5% | low |
| SUSE Manager | 276 | 14.5 | 99.7% | mid |

```latex
\begin{table}[t]
\centering
\caption{Concurrent scan throughput (1,000 hosts).}
\label{tab:e2-scan}
\begin{tabular}{lrrrl}
\toprule
Platform & Throughput (hosts/s) & P99 (s) & Delivery & Max concurrency \\
\midrule
KMOMP & 1847 & 2.8 & 99.99\% & high \\
Satellite 6.14 & 312 & 12.0 & 99.8\% & mid \\
Ansible AWX & 89 & 45.0 & 99.5\% & low \\
SUSE Manager & 276 & 14.5 & 99.7\% & mid \\
\bottomrule
\end{tabular}
\end{table}
```

## Package dispatch

Package dispatch installs one software package on each of the 1,000 hosts and counts a delivery only after the package database reports the requested version. Table 14 uses the same columns as the scan.

Table 14 is withheld until `eval/e2/measurements.csv` has throughput, P99, delivery, and max concurrency for all four platforms on the package workload.

Before those cells are filled, record the package identity (name and version), its size in bytes, and whether the bytes were served from a local mirror. Every host in the wave installs that same package. A row is complete only when all four metric columns are present; a single filled cell is rejected so a partial platform cannot be published.

## Configuration dispatch

Configuration dispatch writes one configuration unit on each of the 1,000 hosts and counts a delivery only after a read-back matches the desired content. Table 15 uses the same columns as the scan.

Table 15 is withheld until `eval/e2/measurements.csv` has throughput, P99, delivery, and max concurrency for all four platforms on the config workload.

The unit is one file or one key, identical across the 1,000 hosts. Record its size in bytes. Success is a checksum match on the read-back plus an accepted server ack, the same delivery denominator as Table 13 and Table 14.

## Filling Tables 14 and 15

Edit the `package` and `config` rows in `eval/e2/measurements.csv`. Then:

```bash
python3 eval/e2/e2_tables.py
python3 eval/e2/e2_tables.py --format latex
python3 eval/e2/e2_tables.py --require-all
```

`--require-all` exits 0 only when both new workloads are complete. Until then it exits 2 and names the missing workload. If the surrounding paper already uses Table 14 and Table 15 for other results, renumber these two captions; the column schema stays the one in Table 13.
