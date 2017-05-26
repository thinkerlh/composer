(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� z8(Y �]is�����
�~y?x�m���6������[)vwT�_A�L��$f�ykx�&hw�4}�l�飛�Mt�F�`�_>H�&�+J������8�b���Aq�@�����clӍ��j_6����/�{��
��c�O�Ih��G{3�V釬���O�Qѿ�F���W����G*���7ӿx�Nqp9�Q��*�������_������O����_���?��(�_Y�ӟ,�W�/��5��N�
;�����Q���;Z?���{�%�\�w>i<�pG�$�6?k�Z�?��4B�����yNٔK�(M�(M�Iظ�E����OS$����Q����O�7�g��
?G�?�?E�(�q},���s��R������ '6d�&�B�z�lC��E�T)M��(�2��I}a,0���G	�;e�ւ6U�	�U���I�ϯ}�`!���h�	Z��Աbc���#��s=$(��!
�ܤu�'����p:�IH��$�L�	kW�ˋ#Y�E�[��Җ(z5�����t��
/=��=ѿ)~��mo9]�~���cx��GaT��W
>��wW����_>��+�%p��'�J����uC�d>���_������� �9ʚ���x��v̐�Ys%�ZD� m.ד����4̸P���5K05�!f-sp%�@"�)m�R{8޹K2�q�pک��+� ���8>@֐��#u�E]���Ev����Q܋�q�jr@1�&��Z=w���A�!⊠dJq=Z�bF#���2����2K;
��G0Qx�T���й������i,����Cq/���\����M������8Zs?*���a�b&d�y�l������[+���
�4��Ym�P<�P��&W� �����$�6o���b�IdB؍�i�v�k���RuN�Um
h����\2T�p7ByWZi�����՝)�Ե����y
 ����L��L��3�;�A��ϼ \���-5<��XR�����u���(��E�$����7�k&@f+��(�t isy�1����V�9)y��@����u��H�b|[$����1���ќ׏�Czķ��ogrȭ&IKj��������4��Er$Ǣ͙E/���L�}X|`6<[�7g��_���4|������V��|��?�^���S���]��2��g��w�w�_j�a�l���zov��yƇ�܎��q���P�i�K*�#��v�
|Hʐ�zGE󫂩�d�e��e�ޗ)��珠u��e��i(��A�ل��,��>/ك�\L��$p�k�jXC"�W���TcSww��yX��a����"�31��������( ͽ���K���2��]�թ� ��TuhM�����)�zKӔ�FN���U {��y����:�q������xH�8�t�=܇�.���|K3ymJ
�(�Hs=]4���Lrآ��F>�>��6s4!��7�8��D���͛X�����P���o�m��D����0��Z<��h�Y�!���&��x}��$�]���]���d�Q
>��?s�����G����J�>*����+��ϵ~A��9&�r��{�t����/��3�*��T�?U�ϯ�?�St��(Fxe���	p�d��CД�4�2��:F����A.�q�#�*���B����Q�E���W.����=qpw4)he�Hc=A]���\���х��V��/��ldcvm+��qC�����l�Zʰo��q��%ǜ�L7�d7���csc��V�p{�nX@�b$�oW�=�������3����R�Q�������e���������j��]��3�*�_
>����?$����J�������7s(|)t�0�7۸ ���?]�f����bX������gb64���������	T8.Sy �Ȥ��O꽩4��s�m��{�;�;Ԓt��$��P�3��m��7�y�ֻ�`�hJEx�3�J��;Y�#��ݓZטBm����lPD$�{�����Y�i�fQ%�S�q�3 ��l(bK Ӑ���3'���|��k�2	]X�7h�y��磅iϞ,�P���I`*�e��w{�χf}yX@�I�F�M���^��Ҳ��h�����j"8���cq)e#���K�HȜ'pr�5CZ�?^�?�/��ό��+�_>����S��RP����_���=�f����Nv��G���������_������T��RP��J�W������C�J=�4/A���2p����t���GC�'��]����p�����Q�a	�DX�qX$@H�Ei�$)�����P�/��C����+���L���z�*�7�[c�`��Ǟ#���~�Ǟ� ���P�;au괒PCCrG��$�W�x=�`O@����0c���������<.���`�ʆ7y��)%���Y��n<��(����S�_���4Q����7��{�;���c���������2�p9�q�������
o_�,.�?��XE�2���8����_����R�;��`8���']����O��F���g1"`1Ǳm�el��P��%X�=,�h��]�� g	&�f�G����P�/����"�S�����`������$����1���m,Y&�g\=R�����������&\xծ��sX]W|.A�D�;��͗��p���2��K���n�������vj=qMP��1ff�^�����/}��GP��W
~�%���U�����'����K��*��2��������o"�	+�����.�<�{��ΑX�Qеr�%,�!?��<�}t�gI ����{7����*-û����]�wi��D�o�ݰ偆�A�74�`h�C;�L(�|�#�W:�\��G�m;��~~HLW����,�-b�Zt3I�K<���39ơ&���k�͛#���T�����f�f����e�'�n��(B�ld�ψA��:�����Zb��x�����y�ք~ހNQe�6�xN��ܩ�۝�ؐ�����^��.uF$��m�4K�|���0���X���M�i����o(����]g+�ӌsV)O	kg�O�� r�@ 5�ý�I'�I�D��5?�}z���u}�H��Ґ^<�G������������/����;{�����s�����[���j�?;�I�d������G���Ǹ0���-��Kf��������������䙡��7P���A���>9��my�@M�wC��-���|Ѓ�����nBJ�Hڡ��';����]�5����Ԅh�{ķf*�n�	C:�Θ8u�Z�������n$���q_��僀�&�x{>���]j�?6�Y�l�9����F�lޥ7ݤo���<m���Ž������Z�-Xr�\o��������i4l����BE8$ǭ�<{�)>R����r���*����?�,��:�S>�����ʠ�{���������G��_��W����������\l�cV��s9����[w�����J���J�W�������-�(���O��o��r�Ox�M���(�8�.C�F��O�L�8��C�O��#��b��`x��B����Q����J����2%[����95#����ͩ����.Y#[j�5y���1X�騭��+�{��z����p�ʍ(�9����Q����-���3�(C�ez��RGYl�C����{�E��Or�_�Q�_�������͹�i�"S���I�K������ (�����ӯP���Hq�զK;���&��O����N2u�\�랡n(�
�F��+{O��g��n�D���ڜ;�ծj�t����M����`��?������>G�&��ǿh�$��u*���^y_k�v���z�G� �v��\��t��^��|h�7:����e�|@�ڕS;��z�gծ����v�?��k���n_������ӕ�ܬ�e�*\��3(opk+ܮ����j_YV��.Z[]]uQ�i�����MG��
A��o���ߋ��k_�+���
�
ھ�T�;?X�����MEI�^�>ʵ����˃���{��{�@���ւ�?�2���;0:��|n���?��H_~آ�&���m��aq����������ygw�����n��A��ޕ}Ͻ�~αE��?m�\�{����fQ2���o�|��Q���(�78M\8�n&[�:Y?`�GT��j�H�\"� D~$�b�9k�-�G�>�;��|�"�۞�����T��l(�\$��.��M �|Wođ�ѐ�;0����*��o�d�?.6��g�^WV�o��t���I�n�����v�-���!��>��u�����{\�w����g��{W�:Y��r���C	r9�e�p1�x��CE�n�v�n��7%מ�k�ukO�wb��L|	�7	!~ b������E��"h0ĈBL�h�m=��v���pA�s�{��������{����<�|��J�4D�
�g�d��ERx6��v��F��L,u)���ønm��1�ѓ�5Y^�ޗ�t�[]�o���4+�cѥ� l�^ ��k@�>��g6�	9���	�B>�h���*K�����������pM4'�F��~� 4��23i�aX�����h�mf�f��xdɈ���麩k�v�X%�;��8�^=<�ߡ$A��Mf�#�m![H�)Z��O�KP/U�*ۑ���fqθ	G�胉�f��8���)��GBdV���q]�����7k��>���b�4d�:*�·*�%�C�n���h�,GS䃍��0�}��� mN�����L6��pz48���)�� ��w��#?��i>���:��b'�/*;T�Ӫ,��{0�����Tk5�.s�렖N�B�A7��SIG�x��~�����~�-�3z:��Ƌ��oFB�����]ѯ}��ߕ��^�
�qjM1�0��]� �,��>��k�㒻��e��1�3�t=l��3����E]䢹@٢F)�<(��v�f� �r�	�Z]�����L^�����smo_��먒�lAU8n�0��~�\��{�=8����'i�L~�I��2�1p^�c�N�qPo�4cosb�1��U~��k�\:>u�os�X����K���kQQ�or�v!�۵�9�eWg��ɩ|E���c�����G��+�G��|�M6���[u���Ǎ���~�A�����?�~���C��vb�����~��W;��T���H��wy\� �� `�m/�������<`��m_���G�WA<��<��=<� '�:{{��;�����n�f�{������.=���A�P�
�V����	�¡:���`7.�x�Ə΁���g�A�>=qn���O@jrƦ����=��0G`$�Sܼ^���9�EE.Ag�]���l��0&���su�0�O!|0�x緙��(,��]>Pm9"���aw,Qv���f���vs�BD��N��f���)˽\�~�J�tA=L���0�b�z����d3����3�mN6t��$�g���9
SJt��0Q��i:KG;��zL���Dx�,�g��fQe��A_�46SE�E&�R�S�g�=J�7JyQ��a9Um	1!����`!�m�TU�X6�^/��8���K!
�ri?r��)�	k3am&�*LX��v;d ,�/�6�����]��[j�p��=5WB֭j��	��E�5%q�A@y��+�d��v�l��z\��Z���M�	��<�
m��h�H()f�d���	�8��̰ä�t93-8�v$�b-���u����X����&L�~`���X%�ZVj�X+��ҟ�E�,VӼx-�%�(i��i�yϰ�U��D�No'�B.H����!�c"�n���+K���e��3ʲ��l�R ˥�o�S)~w���i&?�|�G�E?õ��|�C�Y�կ��a��j�M*X�S����|*WVU�ܦ�,8#�y�(Q:\HUEӴ��㙖��S�=�3�K�%�z��GӾ!Ih]>F�
��i�:������MZ�SY�j1�݉*h?��U*���\�)�{�j��%�>WU\xo�%�HY�������WP�(����[.�����!A�M�I�3Ԛ����J��[xa�a5�+Ѣ���k'��r��7��FbRM 9�>����dM�"�Ue$�&�Jg���)��٥�6a�Ї�-V��i��
0�d�^�_k,!�ل��!��- ��lHꎏH���ʵ	)��ꞡ�&E�A	�'Y�4����i�l��f�l��l�p#�9QpMA��yU�>�[�ڀ֠S��kWl����~��2y��� 9t�ۧ�Cg��_9]U�g+��j�.p]�ms�b�;m�F�p���jj�������研,ոtt#��8^i�4:�q'���Ҽ�Vk�WZ���zB?÷���(<��'5Y�-'��lM�6䡛��k`�ᇟC�>��úM��9g�3kWA`�{��%s�4(�yV�U̖C�@����Z�c�<��,��i��S\V��ypW�/F>sz2+f�z�@t�'ʪ��L���Y ��f$}�Q��Y����GnE^�^��Z����[��R`���R���C�h����� �"	���t�B��[��g+;��p�Z�H����Ƣ���h�0�%k8z�`�K{�8�NZLOc�YS��{��A$�D��)��M��/�^��F,�J�.�▖h��D+�DCH�C�^��B"(t���-��G�s���I�+���a�B�S�C#{0p ���-&��|���q�����xH7��51"�%j���A�!�no<�`UW��b4SˑL#�a0җ����}B�.P����������a҂]�+[�k�a��9��!�	�}��-Q�")D�#��u�LS &�Co9���>.մb/��}��i�m�q�Ǻv�����t��)�������i�����ݡ�:��z贕a��xX�=,��[�O���޿���,�I��D�VD2S��Q
W�H���\���1/;���@����3�<X��u��E��$&���
��"�͚����x[��3��0jSI`bJى�!2(��d
G�vJ�Ԗ+�0���������]&�xY�p#�QnO���0<�}Q8]JI���t0do,6�!
��<��.�	�[j���g��;(EyrHԕ(t��+}t���<@�^�,���G��U����I^�È�2	��g�~����%��;��&&�$ι �ɒ�V��r�n���]�z��]�ye�6�8�ߌ�Pޏ{6ⷒS�>�S6�c���J!��l��f�.Ķ�(�����i���Q�h���tÔ��8��W**�i������>�%~���%A�oAlB�Ne����;��J�r�\�h��<NB'�+,7�"��]�>��7�Z/��i�~�[/=������Ky��C����fW���|7;ͦ�Տ�����w��>����,	87�>���<Hw_z�������oz��7���'������'����Sq�8��[׮4�~�W&W�t��FӉjh:�F��W~�c�|��;���8=�x�7���=	�N��(���)j�N��Yj�6�Ӧv��N�&`�lj������H�i��iS;mj����>����yh��e�^8�r��%���,4�6y�m!t�����o=fb褏���!��<��5�E���n��3�?�ڟRm��m�q�g<�#p$���d��zmj��2O˞3cG[�93�� {Z�=g�6�8.Ü�#��=���13��q��Z[����G���y\�R�����v����d��m�/��L�  