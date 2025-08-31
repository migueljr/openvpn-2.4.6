cp -r /usr/share/easy-rsa/ /etc/openvpn

./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa gen-req server nopass
./easyrsa sign-req server server


./easyrsa gen-req corpoperfeito nopass
./easyrsa sign-req client corpoperfeito

./easyrsa gen-req powerfitness nopass
./easyrsa sign-req client powerfitness

./easyrsa gen-req client3 nopass
./easyrsa sign-req client client3

./easyrsa gen-req client4 nopass
./easyrsa sign-req client client4

./easyrsa gen-req client5 nopass
./easyrsa sign-req client client5

openvpn --genkey --secret pki/ta.key
