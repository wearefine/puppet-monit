FROM centos:7

RUN rpm -Uvh https://yum.puppet.com/puppet-tools-release-el-7.noarch.rpm \
    && yum -y install pdk-1.10.0.0 \
    && yum -y install gcc-c++ make git

ENV PATH="/opt/puppetlabs/pdk/private/ruby/2.4.5/bin:${PATH}"
RUN gem update --system

RUN mkdir -p /root/project

WORKDIR /root/project
COPY . .

RUN rm -rf Gemfile.lock spec/fixtures/modules/* \
    && bundle install --without system_tests --path=${BUNDLE_PATH:-vendor/bundle}
