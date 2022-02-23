- **todis 使用的 grafana 和 prometheus 安装脚本，安装在 todis 主机上；**  
- **请勿在已有 grafana 和 prometheus 服务的主机上执行脚本。**
- 操作系统支持centos 8 和阿里云 ecs 系统，其他系统未测试。

# 1、安装

#### 下载
download.tar.gz 是安装过程用到的 rpm 包和 grafana 修改内容。
```
git clone https://github.com/topling/todis-grafana-install-shell.git
cd todis-grafana-install-shell
wget "https://github.com/topling/todis-grafana-install-shell/releases/download/download_file/download.tar.gz"
tar xf download.tar.gz
```

#### 安装
cd install; 执行`sh install.sh`即可完成安装。

配置内容在 config.sh，如下示例：
```
grafana_admin_password=1234567
enable_admin_dashboard=false # false or anything 
  
function server_config() {
    # server config
    prometheus_port=9090
    prometheus_listen_port=9090
    prometheus_host=localhost
    grafana_host=localhost
    grafana_port=3000
    todis_host=localhost
    todis_port=8000
}
```
- grafana_admin_password 是 grafana 的管理员密码，安装过程会修改 admin 的默认密码 admin 为 grafana_admin_password 的内容；  
- enable_admin_dashboard 设置是否安装两个管理员可见的 dashboard，注意是主机状态和进程状态监控，默认不安装，非 false 表示安装；  
- prometheus_port 是 prometheus 外部访问端口；  
- prometheus_listen_port 是 prometheus 的启动参数设置端口，该设置是为了适应 docker 环境的端口映射，如果是使用一般主机设置和 prometheus_port 相同即可；  
- prometheus_host 主机地址；  
- grafana_port 监听端口设置；  
- **todis_host todis 主机地址；**  
- **todis_port todis 主机 http 接口端口号。**

主要是 todis_host 和 todis_port 对应 todis 的相关配置即可。
### 安装过程可能创建目录
```
/usr/local/node-exporter
/usr/local/process-exporter
/usr/local/grafana
/usr/local/prometheus
/data/prometheus
```

# 2、grafana 扩展功能
histogram 的 dashboard 使用了我们自己扩展的 grafana 功能，详细内容参见[针对 Grafana 监控效果的一个改进](https://blog.topling.cn/posts/%E9%92%88%E5%AF%B9%20Grafana%20%E7%9B%91%E6%8E%A7%E6%95%88%E6%9E%9C%E7%9A%84%E4%B8%80%E4%B8%AA%E6%94%B9%E8%BF%9B/)。

