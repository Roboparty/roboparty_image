# SSH 开机启动

镜像构建明确启用 `ssh.service`，并安装其依赖
`robopi-ssh-hostkeys.service`（Type=oneshot）。后者执行 `ssh-keygen -A`，
成功后 SSH 才启动；无需登录串口手动生成密钥。

封装镜像前删除 rootfs 内的默认 SSH 主机密钥，避免不同板子共用镜像构建时
生成的身份。首次启动生成每板独立密钥，后续重启只补缺失密钥，不覆盖已有密钥。
`orangepi-firstrun` 不再删除密钥或重启 SSH。用户名、密码和 SSH 登录策略不变。

修改后需要重新构建完整镜像（不是只重编内核），再烧录验收。
构建脚本会显式安装相关文件，以兼容旧 BSP 缓存；不要将本修改理解为对当前
已经烧录的板子进行了远程更新。

## 首次开机验收

先不要手动执行 ssh-keygen 或启动 SSH，通过串口查看：

```bash
systemctl is-enabled ssh
systemctl status robopi-ssh-hostkeys.service ssh.service --no-pager -l
sudo ss -lntp | grep ':22'
sudo journalctl -b -u robopi-ssh-hostkeys -u ssh --no-pager
sudo ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
```

预期 SSH 为 enabled / active (running)，密钥准备服务为 active (exited)，
22 端口监听。用另一台电脑进行实际 SSH 登录测试。
再次重启后确认 SSH 自动启动、主机密钥指纹不变；另一块新烧录板子的指纹应不同。
密钥准备失败会阻止 SSH 启动，具体错误保留在 journal 中，不报告虚假的成功。

## 本次验证范围

已进行 shell 语法与补丁空白检查；完整镜像构建、首次开机、重启和跨板密钥唯一性
仍需按上述步骤验证。
