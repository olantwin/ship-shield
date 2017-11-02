FROM scr4t/ship-base:13.03.2017

RUN yum -y install yum-plugin-ovl
RUN yum -y install python2-pip
RUN yum -y autoremove
RUN find /usr/share/locale | grep -v en | xargs rm -rf
RUN yum clean all

RUN /bin/bash -l -c "\
        rm -rf opt/FairShipRun /opt/FairShip &&\
        git clone -b optimisation_shield https://github.com/olantwin/FairShip.git /opt/FairShip  &&\
        cd /opt/FairShip &&\
        git checkout 25993a047d7853e4774ddcb1834a274003fdcacd &&\
        mkdir -p /opt/FairShip/../FairShipRun &&\
        cd /opt/FairShip/../FairShipRun &&\
        cmake /opt/FairShip -DCMAKE_INSTALL_PREFIX=$(pwd) -DCMAKE_CXX_COMPILER=$(/opt/FairSoftInst/bin/fairsoft-config --cxx) -DCMAKE_C_COMPILER=$(/opt/FairSoftInst/bin/fairsoft-config --cc) &&\
        make"

RUN /bin/bash -l -c "\
        git clone -b disneyland https://github.com/olantwin/muon_shield_optimisation.git /code &&\
        cd /code &&\
        git checkout e5ac7d85bd67ede8c75a4473f3732bce2e02bfdf"

RUN /bin/bash -l -c "\
        source /opt/FairShipRun/config.sh &&\
        pip install $(grep Cython /code/requirements.txt) &&\
        pip install $(grep numpy /code/requirements.txt) &&\
        pip install -r /code/requirements.txt"
