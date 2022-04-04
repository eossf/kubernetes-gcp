https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	01-prerequisites.md

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

------- GCP 
 3 workers
 3 masters
 
------- GCLOUD
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-245.0.0-linux-x86_64.tar.gz
tar -zxvf google-cloud-sdk-245.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh

   Your current Cloud SDK version is: 245.0.0
   The latest available version is: 258.0.0
  ┌───────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
  │                                                   Components                                                  │
  ├──────────────────┬──────────────────────────────────────────────────────┬──────────────────────────┬──────────┤
  │      Status      │                         Name                         │            ID            │   Size   │
  ├──────────────────┼──────────────────────────────────────────────────────┼──────────────────────────┼──────────┤
  │ Update Available │ BigQuery Command Line Tool                           │ bq                       │  < 1 MiB │
  │ Update Available │ Cloud SDK Core Libraries                             │ core                     │ 11.4 MiB │
  │ Update Available │ Cloud Storage Command Line Tool                      │ gsutil                   │  3.6 MiB │
  │ Not Installed    │ App Engine Go Extensions                             │ app-engine-go            │ 56.6 MiB │
  │ Not Installed    │ Cloud Bigtable Command Line Tool                     │ cbt                      │  7.4 MiB │
  │ Not Installed    │ Cloud Bigtable Emulator                              │ bigtable                 │  6.6 MiB │
  │ Not Installed    │ Cloud Datalab Command Line Tool                      │ datalab                  │  < 1 MiB │
  │ Not Installed    │ Cloud Datastore Emulator                             │ cloud-datastore-emulator │ 18.4 MiB │
  │ Not Installed    │ Cloud Datastore Emulator (Legacy)                    │ gcd-emulator             │ 38.1 MiB │
  │ Not Installed    │ Cloud Firestore Emulator                             │ cloud-firestore-emulator │ 36.7 MiB │
  │ Not Installed    │ Cloud Pub/Sub Emulator                               │ pubsub-emulator          │ 34.8 MiB │
  │ Not Installed    │ Cloud SQL Proxy                                      │ cloud_sql_proxy          │  3.8 MiB │
  │ Not Installed    │ Emulator Reverse Proxy                               │ emulator-reverse-proxy   │ 14.5 MiB │
  │ Not Installed    │ Google Cloud Build Local Builder                     │ cloud-build-local        │  6.0 MiB │
  │ Not Installed    │ Google Container Registry's Docker credential helper │ docker-credential-gcr    │  1.8 MiB │
  │ Not Installed    │ gcloud Alpha Commands                                │ alpha                    │  < 1 MiB │
  │ Not Installed    │ gcloud Beta Commands                                 │ beta                     │  < 1 MiB │
  │ Not Installed    │ gcloud app Java Extensions                           │ app-engine-java          │ 85.9 MiB │
  │ Not Installed    │ gcloud app PHP Extensions                            │ app-engine-php           │          │
  │ Not Installed    │ gcloud app Python Extensions                         │ app-engine-python        │  6.0 MiB │
  │ Not Installed    │ gcloud app Python Extensions (Extra Libraries)       │ app-engine-python-extras │ 28.5 MiB │
  │ Not Installed    │ kubectl                                              │ kubectl                  │  < 1 MiB │
  └──────────────────┴──────────────────────────────────────────────────────┴──────────────────────────┴──────────┘

gcloud init

  * Commands that require authentication will use stephane.metairie@gmail.com by default
  * Commands will reference project `kthw-249811` by default
  * Compute Engine commands will use region `europe-west3` by default
  * Compute Engine commands will use zone `europe-west3-c` by default

------- Install tmux
yum groupinstall "Development Tools"
yum install libevent -y
yum install libevent-devel -y
yum install ncurses-devel -y

wget https://github.com/tmux/tmux/releases/download/2.9/tmux-2.9.tar.gz
tar -zxvf tmux-2.9.tar.gz
cd tmux-2.9
./configure
make
make install
ln -s /usr/local/bin/tmux /usr/bin/tmux

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	02-client-tools.md

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

------- Install CFSSL
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64
mv cfssl_linux-amd64 /usr/local/bin/cfssl
mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
ln -s /usr/local/bin/cfssl /usr/bin/cfssl
ln -s /usr/local/bin/cfssljson /usr/bin/cfssljson

-------- kubectl
wget https://storage.googleapis.com/kubernetes-release/release/v1.15.2/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/
ln -s /usr/local/bin/kubectl  /usr/bin/kubectl

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

03-compute-resources.md

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-------- Virtual Private Cloud Network

gcloud compute networks create kubernetes-the-hard-way --subnet-mode custom

  Created [https://www.googleapis.com/compute/v1/projects/kthw-249811/global/networks/kubernetes-the-hard-way].
  NAME                     SUBNET_MODE  BGP_ROUTING_MODE  IPV4_RANGE  GATEWAY_IPV4
  kubernetes-the-hard-way  CUSTOM       REGIONAL

  Instances on this network will not be reachable until firewall rules
  are created. As an example, you can allow all internal traffic between
  instances as well as SSH, RDP, and ICMP by running:

  $ gcloud compute firewall-rules create <FIREWALL_NAME> --network kubernetes-the-hard-way --allow tcp,udp,icmp --source-ranges <IP_RANGE>
  $ gcloud compute firewall-rules create <FIREWALL_NAME> --network kubernetes-the-hard-way --allow tcp:22,tcp:3389,icmp

gcloud compute networks subnets create kubernetes --network kubernetes-the-hard-way --range 10.240.0.0/24

  Created [https://www.googleapis.com/compute/v1/projects/kthw-249811/regions/europe-west3/subnetworks/kubernetes].
  NAME        REGION        NETWORK                  RANGE
  kubernetes  europe-west3  kubernetes-the-hard-way  10.240.0.0/24

-------- Firewall Rules


gcloud compute firewall-rules create kubernetes-the-hard-way-allow-external --network kubernetes-the-hard-way --allow tcp,udp,icmp 
#--source-ranges <IP_RANGE>
#gcloud compute firewall-rules create <FIREWALL_NAME> --network kubernetes-the-hard-way --allow tcp:22,tcp:3389,icmp
  
gcloud compute firewall-rules create kubernetes-the-hard-way-allow-internal \
  --allow tcp,udp,icmp \
  --network kubernetes-the-hard-way \
  --source-ranges 10.240.0.0/24,10.200.0.0/16
  
  Creating firewall...⠶Created [https://www.googleapis.com/compute/v1/projects/kthw-249811/global/firewalls/kubernetes-the-hard-way-allow-internal].
  Creating firewall...done.
  NAME                                    NETWORK                  DIRECTION  PRIORITY  ALLOW         DENY  DISABLED
  kubernetes-the-hard-way-allow-internal  kubernetes-the-hard-way  INGRESS    1000      tcp,udp,icmp        False

-------- Kubernetes Public IP Address

gcloud compute addresses create kubernetes-the-hard-way --region $(gcloud config get-value compute/region)
gcloud compute addresses list --filter="name=('kubernetes-the-hard-way')"


-------- 6 Compute Controllers + Workers

for i in 0 1 2; do
  gcloud compute instances create controller-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family centos-7 \
    --image-project centos-cloud \
    --machine-type n1-standard-1 \
    --private-network-ip 10.240.0.1${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes \
    --tags kubernetes-the-hard-way,controller
done

for i in 0 1 2; do
  gcloud compute instances create worker-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family centos-7 \
    --image-project centos-cloud \
    --machine-type n1-standard-1 \
    --metadata pod-cidr=10.200.${i}.0/24 \
    --private-network-ip 10.240.0.2${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes \
    --tags kubernetes-the-hard-way,worker
done

-------- Configuring SSH Access

gcloud compute ssh controller-0
