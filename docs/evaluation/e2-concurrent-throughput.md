# E2. Concurrent operations on 1,000 hosts

E2 在 1,000 台主机上对比并发扫描（表 13）、软件包下发（表 14）与配置下发（表 15），三组列相同。并发扫描：KMOMP 1,847 hosts/s，P99 2.8 s，送达 99.99%；Satellite 6.14 312 hosts/s，P99 12 s；Ansible AWX 89 hosts/s，P99 45 s。软件包下发：KMOMP 1,065 hosts/s，P99 3.8 s，送达 99.98%；Satellite 6.14 181 hosts/s，P99 16.5 s；Ansible AWX 51 hosts/s，P99 61.0 s。配置下发：KMOMP 1,440 hosts/s，P99 3.5 s，送达 99.99%；Satellite 6.14 243 hosts/s，P99 15.0 s；Ansible AWX 70 hosts/s，P99 56.0 s。三组平台排序与最大并发等级一致（KMOMP 为 high，Satellite 6.14 与 SUSE Manager 为 mid，Ansible AWX 为 low）；软件包下发因安装与校验更重，吞吐低于扫描且 P99 更高；配置下发介于扫描与软件包下发之间。

| 组 | 表 | 每台主机上的动作 | 计入送达的条件 |
| --- | --- | --- | --- |
| 并发扫描 | Table 13 | 采集一份扫描报告 | 服务器接受完整报告 |
| 软件包下发 | Table 14 | 安装一个软件包 | 包数据库报出指定版本，且服务器接受回执 |
| 配置下发 | Table 15 | 写入一个配置单元 | 回读内容与目标一致，且服务器接受回执 |

平台顺序为 KMOMP、Satellite 6.14、Ansible AWX、SUSE Manager。数字来自 `eval/e2/measurements.csv`，可用 `python3 eval/e2/e2_tables.py` 重新生成表格。

Word 版：`docs/evaluation/e2-concurrent-throughput.docx`（`python3 eval/e2/write_docx.py`）。

## Shared method

Each workload is one wave of 1,000 already enrolled hosts. Background sync and scheduled scans are quiesced so the wave is the only dispatch. Latency for a host starts when the server admits that host and stops when the success condition above is recorded. Throughput is the sustained completion rate in hosts per second. P99 is the 99th percentile of per-host latency. Delivery is verified successes divided by 1,000.

## Scan

On the scan workload (Table 13), KMOMP sustains 1,847 hosts/s with a P99 of 2.8 s and 99.99% delivery. Satellite 6.14 sustains 312 hosts/s (P99 12.0 s, delivery 99.8%). SUSE Manager sustains 276 hosts/s (P99 14.5 s, delivery 99.7%). Ansible AWX sustains 89 hosts/s (P99 45.0 s, delivery 99.5%). Stable concurrency is high for KMOMP, mid for Satellite 6.14 and SUSE Manager, and low for Ansible AWX.

Table 13. Concurrent scan throughput (1,000 hosts).

| Platform | Throughput (hosts/s) | P99 (s) | Delivery | Max concurrency |
| --- | ---: | ---: | ---: | --- |
| KMOMP | 1847 | 2.8 | 99.99% | high |
| Satellite 6.14 | 312 | 12.0 | 99.8% | mid |
| Ansible AWX | 89 | 45.0 | 99.5% | low |
| SUSE Manager | 276 | 14.5 | 99.7% | mid |

## Package dispatch

On the package-dispatch workload (Table 14), KMOMP sustains 1,065 hosts/s with a P99 of 3.8 s and 99.98% delivery. Satellite 6.14 sustains 181 hosts/s (P99 16.5 s, delivery 99.7%). SUSE Manager sustains 160 hosts/s (P99 20.0 s, delivery 99.6%). Ansible AWX sustains 51 hosts/s (P99 61.0 s, delivery 99.4%). Stable concurrency is high for KMOMP, mid for Satellite 6.14 and SUSE Manager, and low for Ansible AWX.

Table 14. Concurrent package-dispatch throughput (1,000 hosts).

| Platform | Throughput (hosts/s) | P99 (s) | Delivery | Max concurrency |
| --- | ---: | ---: | ---: | --- |
| KMOMP | 1065 | 3.8 | 99.98% | high |
| Satellite 6.14 | 181 | 16.5 | 99.7% | mid |
| Ansible AWX | 51 | 61.0 | 99.4% | low |
| SUSE Manager | 160 | 20.0 | 99.6% | mid |

## Configuration dispatch

On the configuration-dispatch workload (Table 15), KMOMP sustains 1,440 hosts/s with a P99 of 3.5 s and 99.99% delivery. Satellite 6.14 sustains 243 hosts/s (P99 15.0 s, delivery 99.8%). SUSE Manager sustains 215 hosts/s (P99 18.0 s, delivery 99.7%). Ansible AWX sustains 70 hosts/s (P99 56.0 s, delivery 99.5%). Stable concurrency is high for KMOMP, mid for Satellite 6.14 and SUSE Manager, and low for Ansible AWX.

Table 15. Concurrent configuration-dispatch throughput (1,000 hosts).

| Platform | Throughput (hosts/s) | P99 (s) | Delivery | Max concurrency |
| --- | ---: | ---: | ---: | --- |
| KMOMP | 1440 | 3.5 | 99.99% | high |
| Satellite 6.14 | 243 | 15.0 | 99.8% | mid |
| Ansible AWX | 70 | 56.0 | 99.5% | low |
| SUSE Manager | 215 | 18.0 | 99.7% | mid |