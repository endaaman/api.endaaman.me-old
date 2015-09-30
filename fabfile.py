from fabric.api import task, run, cd, env

env.hosts = '133.242.149.25'
env.port = 4545
env.user = 'endaken'
env.key_filename = '~/.ssh/sakura'

def deploy():
    with cd('/var/www/enda-api'):
        run('bash build.sh')
