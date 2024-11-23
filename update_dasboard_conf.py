from secrets import token_urlsafe

import yaml


class UpdateConfigs:
    def __init__(self):
        self.internal_networks = [
            "10.0.0.0/8",
            "172.16.0.0/12",
            "192.168.0.0/16",
            "127.0.0.0/8"
        ],
        self.user_credentials = [
            {"username": "admin", "password": token_urlsafe(16)},
            {"username": "user", "password": token_urlsafe(16)}
        ]
        self.admin_credentials = {"name": "admin", "role": "admin", "key": token_urlsafe(32)}

        self.apisix_config_path = 'apisix_conf/config.yaml'
        self.dashboard_config_path = 'dashboard_conf/conf.yaml'

    def update_apisix_conf(self):
        # 讀取現有配置文件
        with open(self.apisix_config_path, 'r') as file:
            config = yaml.safe_load(file)

        # 更新管理憑據
        deployment_config = config.get('deployment', {})
        admin_config = deployment_config.get('admin', {})

        admin_key = {
            'key': self.admin_credentials['key'],
            'role': self.admin_credentials['name'],
            'name': self.admin_credentials['role']
        }

        if 'admin_key' not in admin_config:
            admin_config['admin_key'] = []

        for existing_key in admin_config['admin_key']:
            if existing_key['name'] == admin_key['name']:
                existing_key.update(admin_key)
                break
        else:
            admin_config['admin_key'].append(admin_key)

        admin_config.update({
            'admin_api_version': 'v3',
            'enable_admin_cors': True,
            'admin_key_required': True,
        })

        deployment_config['admin'] = admin_config
        config['deployment'] = deployment_config

        # 寫入更新後的配置文件
        with open(self.apisix_config_path, 'w') as file:
            yaml.dump(config, file, default_flow_style=False)

        print("Apisix configuration updated successfully.")

    def update_dashboard_conf(self):
        # 配置文件路徑
        # 讀取現有配置文件
        with open(self.dashboard_config_path, 'r') as file:
            config = yaml.safe_load(file)

        # 更新用戶憑據
        auth_config = config.get('authentication', {})

        # 用戶列表判斷
        if 'users' not in auth_config:
            auth_config['users'] = []

        # 更新用戶
        for new_user in self.user_credentials:
            for user in auth_config['users']:
                if user['username'] == new_user['username']:
                    user['password'] = new_user['password']
                    break
            else:
                auth_config['users'].append(new_user)

        config['authentication'] = auth_config

        # 寫入更新後的配置文件
        with open(self.dashboard_config_path, 'w') as file:
            yaml.dump(config, file, default_flow_style=False)

        print("Dashboard Configuration updated successfully.")


if __name__ == '__main__':
    update_configs = UpdateConfigs()
    update_configs.update_apisix_conf()
    update_configs.update_dashboard_conf()
    print("All configuration updated successfully.")
    print(f"user_credentials: {update_configs.user_credentials}")
    print(f"admin_credentials: {update_configs.user_credentials}")
    print("=" * 20)
