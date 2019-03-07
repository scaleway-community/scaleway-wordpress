def jenkinsfile
node {
    checkout([
        $class: 'GitSCM',
        poll: false,
        branches: [[name: 'mlegarrec/10G_image_size']],
        userRemoteConfigs: [[url: 'https://github.com/scaleway/image-tools.git']]
    ])
    jenkinsfile = load 'jenkins/image.groovy'
}

jenkinsfile()
