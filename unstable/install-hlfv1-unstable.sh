ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data-unstable"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

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

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �4�Y �=�r�Hv��d3A�IJ��&��;ckl� 	�����*Z"%^$Y���&�$!�hR��[�����7�y�w���^ċdI�̘�A"�O�έ�U���Pp��-���0�c��~[t? ��$�?��)D$!�H��q)	QR.�"B�����X64xd���Y��=��B����m�,���,dv5Y����6�L�6�d~0`m�O�C����� SGj����1�b�lږK� x�%l	���3V���fb��{��:(T2���b6��?z ��?Q�h���N����Ȇ*�!A�����)!H���X[��A�2e����
�0��ӁU�b"�V,T�*���j�bc����n���jB�@��;���'�ٴy�Rl2i�&�k:Z<��7mM�k��,��,��:�� ���@�U]1(,�`�*^k]qb���^����CM�F>��>C��S�*jP����v�2Ga6Ud�[���gԧ�:�z��(ۡ�G9�.`��#:��8Q���`>S,��m}8Qâ��V'��u̆X�.�U�-���ߴ����Н��LD��9�����#�`����裃,���?�̔�0s���ݧ����oJ1�ɼs;�2&b��pt��`Dq���a��슊���=�.ldPڒI�����>��|�j����j�	��������y���#@�?I��/z�=�_��7c�mD�(�3\���wm��t���d���G#R8,J���K����_<�.TӌPZM�� �?}��S5�jL��*)Wv?T�ʩ�[����<��{���S胎!q6�|����3��>]��*�bx-������0C�;Pi�
�[ظ�6���4��O�)�������n:��uf`ȱ1^
��[:}4��2A��Y�ƀά�ـ:6�^��tܡ�b���l�qL�3���Zڴk�� Vd"�\����O���f{�� �lhɓ�S�����3Jc�
����)�c7�9}��j���5k[&R�D��wE�ȎT���������Xi)M����:���{o�;� �aEc�W~�ٷF�Ps4]@Sij]��7���ˁ���!Z@�{4Z���� ����H0�'��@�Rs�A�?�s����$���Av5�k���`��O��4{;tWp��&O'�Xi��W���P/����	m��t@C&j�."���ahFc�R���J��;�7�+�;w�>W��79��Ro�P$�w;����W��ATR��{�=J�f����}�G"���X?e����Ó�����s[/�A��I�f0� P���,f�	���ޒY Z��	�\6g��N{�?L����uX�=�K K�1�+�cc���s�����,�Nydh7y��`o�����ل�ͯ���>�9��v�>�X�:�G.Bȕ�f�h�UL>��&�(�;�Dv�CA�H�A��)M��g~<�~�v�3��6و�f��7�<m���<B}h]6��۟�����F�6����G��l2qz@�D����q�eѝ�W�+��<t��^9��©�@k����O���~(���'�k��
X��|�0C�GkyOm,�Q
ǧ�_\���\?)=:�q�3�l���OO�v��;fb�稷�3a�u�Ӥ�� �6�\:_��u�Uw��T9X����&�U��=Ϯ���=�C<�]b�r��x�Y9YΧ>gʕ�A���`�6{N��,��_'�rڴ7l��_��50Yaǋ*�n��4	E�x�t��,ݩ\�o�*����B��:��h��.F�s��R��kC���#F�1P��D;���V$޿xʢ�H�o߂�3��3xj"��=�$̹���mP$�8�Ӯ!�?~~��R ҺtN�tzB'�i%LF�o��<����i� (�$�_�����s��p'�E���������X�_6���AӾ��2���´�����
���|����贁f��utLT�.�Ў�~=˾�:w��?�/ݽ�e������}��X��l�s'.����7���_	�t�����G�G��?����J`��o��±A��ed��|	:�f���v���<����#���ba'��c"N.�vw~v���^|J��c"B��tl���Ѿ�`�'V߲Q� #�{֐�D�Y��ҿޫ��X�O��˱�gҙ!�.�����Աu$e#����<~�̿UG\!�	���ŞBݘ	�0��.R����ke�0�:x�3��{g�wJ����i0p(:�����-�M��]����4}��P�o����A�|�Zs�Z���BDl�pu)d�3�R��W��a8�=�q<����@@
Aq�o�� �{�
���[�����&�,^����]���T�M�8Y��J�����d��m�ѴA����~�Ox=4���v�n*�wy)�4�76-�R<���]	�U���?w�����B��)���l H3���瀌��e ��-�]�̣�)�
�"��V�a���� �����i}�P!����,��6z�.zqSwiƳ��LQr�^���l?�Ė�&�AxIC���):&�H�K0��gi&/�ČS��ffΘh}:YƬ��raLu*��ӫ݃Bf�0����)�r����#��s���%3��Ґ�@Z�"��H�?+�wc���1��G�������>��۟���>�_�z�GJ�UOA�bYt�������hTZ������������o��������_��0e~�	Ej�"I��V]QJ�z�.)[�D�^K��p"IDRLJ�I�R"�H���V4\ۊF7��k�/_sӄ7���N�tt��/���6�������G�>�6,lښ�����6�lT��}��&���W�|5�����Y�;k�_6����mp���H��~"8sb�ͫim�a�1A�[�`��h���W0�������w����<�[�q{���5���率�IK����K�u�������O J��J����0)�I���u�Р���'O��6�,巯xKk�s�<���}�"��5�c���ķ"�V}+��T�RR8�OĶT((IP������0%)'Mh>�+^AD�֩��	PHfr�"He��|6���V��(���y*%+����'�F�,��������>~�p���z��i~��/υ��)��}BAn�d�(�lR�ǅ�̥\N6�ǄT5�*6k9�]��v�I�"{.�ϔj��<Ӓ�w���:�a��4�u���o\\����ˌs��٬�IZg��y-,\�e����p����o����6�b�����p�����	-;ge°�qr��JV/U:M�J�L����e�Z GG�J�J�OκJ;�9�fN
ɒ;�B�q�:��Y��$z��k��z!)0��;)��mx��\�JTG����.��v�[�&��L&�d�c�R�r#�K��Ͻ̮,��d��ڻH��\�R-��n��F;�;9�ڱ4���r�ur��o����Q���{Y�V4-Z����:��V��[��;�2�\��w^�&��Dւ�VM�2�P�D�x���t�w˅�\����\HYtTj�WjR{r>�6ϠO擉w�Y�o���;m"yxp`
�l���_Gw	�;�##+����\���d�b�T��V=E��LDO��q�"��GQ�89�'�)5��7*ѽn_�U�ř��{�Dܩ�3�v���SR"�U�Gey��X>SL�~0C��O��h�kF�t̘�g�~� ��!}_@Ř{��?0��&��"�e��������;@S�|aE�d��~���:�o%0�'����8���)+}��]b��E6:�z��P�RC�����B	�U�=���c�"�A�܉�w�l)�归v���J�r�즬�Q��)�.�0qy,�S:~QC�ǜt�:���~4�����n8�5R��c�zFa�ȡ����O�V�F�BR�9��]���_�2�t��G�����S��C_ã_��ϲ����+�q���ϧ������Nw�㏔\�B�rII�r�{f&�>������I�	Y"z����v�1��g�B+��|��9ΖM�e|����[��a���'�[Z�BH�v�F5�rcgg܀O��s��o>A���������~%l��Ǯ�G�u��������"���fv�@�uP�e(#�j�{B�,�o�n�ۀ{�[א�F�o	A�j���t`6,@�5CcS�N����]�i��4�����/�٥��П��_┞����"��Q �qj�6��b���6��W:Ha�XA��tA��B���ё��X��������v�e������3�p�7�b�� ,<��C�oC|P�e�G�;����`�dK�h�&�t�g�E����AtA�4������D�
��1=z��vL�WA 
�/�@�^`�A��R"E����A�t�ѥ��aæ ��i�>m��~٦�,B;Cl���O۶4�%�j�0 �BW=y{2%q </���F����d�O��AQ�������{����"s��7�0��M�j��j�7<��֟AL|SSU=>�I�uSE2�d��b/���&	oO��B௮���A������_H��M[��H�dn�Pw� �&n���1���%�9��ym�&�:�ѺH���Ǵ����1&eZ�]�xR2'������p�bGǱ	�pq-�� ���l)]dY�`����R�s�/N�%���q�pot/zR��T4��D�*a�f �:�h5�\��A�xЗ��u)�1n��Z������n-�*�v; ��;���GrI{�f��=d�<g�6_�W�i�"���P�x^��7=r�0}�w��V�j�MG�]�TT��x38!�EL$�׍�ڡ���Ф�m�v����E����8�#P�vӣ�t7�5m6&jP���^����l��	�*$s��v{�O�u^������s�:�˶�f�s��N�6��#�!��%���<]���`~�����b����7�	��@E��,��Xc��L�>P�c16�#6ܩZ������2�����GL��x�/Jaz��?���� 8��ٻ�XǱ����4w�S�����nԗ*?;�eJj;v��y:OWN�$N�Ǎ�8��4-1Ҁz�؁`��,�° 6#�7���k�9~�y�wUn�:�շ�����s���%��~��?��)��'M��t������?�������>�|�#�Ñ�G�?x��[G?�X���k�bB�?�,L��!Y�0)�#TD�3�4�S(�x8F�[1�TȨ�ٖ�1BY��D3�(����?|9���O�8������?���/�>��q��0�X�w��?����B�ꁿy?���wl��^��9@��}��=D�&����a��"?������p1��
 -�\�X�M7s�h�|lh�XJ!�^�dX���tλ�^._(�t�Ytr[x��B|誆����]��Uŵfd#��X'�)�;#�$Ll�]҄Ыυ^�z�z����g����%��hu��*�PL�ϙc�^���آ9кB�n&h�.ř�h!�)��� ;nٙP�	f8��5��<3���U�l&��:3��i&;0�p�l�^"wg��A5�/8Ug�h������ș�.�Au�A�x^����v�2;�tM1�D.]�S��&�]&�Y	?7gJ�X���dWʶ�f���E,OR(C[k�I:
cik~��D���6Yf��e�г%=���B��;�NR2���uR��ME�\: �4ivGajV�k�E�>췻���&F�-ZUi�_Lz�V�L]�:���cQ�\��259��q]n���ifډ�ɚ�*��4���F�N��lܤ����ON��"rH�-D+z	]��o���?���D�
�DD�
�DD�
�DD�
�DD�
�DDv./a�]��R�&o��$���+���s�nV�b��-q*�m`Z1>\l��^�Ί�BUNΗ�=wQ=x(��V=�=�S=Q3e5� ���X3u;������m/��t����44g��qφ5Ҩ��Vo���(VM}�):!�Ҵz�`j���nMM��k��͑�&���q��M�O�1���q:�$$V河e-G�Z8������[���P�pn^�~2tj��pd�%b���d�4s:Sf�İ^���2�Q���y����3V˦���%s��*7ʹI+��X����v;>�E�w	�y�P��׷�p�z���Q�-��7�^{�6���X^lu���%�{c�+���y/n߂��M��9̏4��|x��k�#��>@�|��uj����_��Y}y3�F�5������Q�{����#W���x������?x��C�=x�W����e�������D]e�Lu��"�%�[[:__��O�t���qb��[f�,,g����Bnc5��t%r��/�[tL��.�ؔ�5�)�8���BA��Ri��e�3+�!0�	𘅐j�Rf�'R�)����8�$z$F���٩��� ��Ա:����ۢ������q�4�0�G��em�HwT~�����D:gK�(��P-KuW"i�r�L�΁�i����F��0M�B҂�v
*g�&���vT��N�+Ǒ�!%G��/�z�4�Vi��_ҧȚ��dS4�p�J�5e��גM\��
��J-��r����&Z����B,#�#4s��lG��P�5�1f�|/F[����ɂ�t�����J��C��ʅz��� L3.���i���������û�?�i '�t�5��A���G��*&\cE.$��E��-�l��F�3�~�z��J�˸�ܖ�]vG��ߣ�N�,�/�oV�i!y=�����thٓ]�&�Ƭ#i�L��'uq��4��pXR���_U�R]&�la��h��A#�[������Q5�룍,M���٬��;T�B�iʜm(��6Omf�1�ɏ�Nu0�Q���Dj>�h��q��=?��tB��L���t�ɴ���KV��ߥizڪE�J�QQҩj_,�c.]���j��@:o\j^,��tX1M���~<��\�n����J�.�Oc8F��9����g7����J�Ȋ@�,V�D����F�c2rW
	[V��d��HFf�v�<�ڏr�#!iBe����U&���T�H�v�U&E`λ
��y�V(��0T(WZ���Ni�<���S�:�b.���\\��U":kJ|������4:V�gQ�12x����Q��i��t�"�ew4�m
�j�
%R�����1S8.MI����,t�34U �{
1o��/����!y=��݌Z�2x'�&��'�J�n�t����� 	k��ұ��d�2*1fi^ǦҠi
57
K���lX[��F�+�X-�]�L�]Z٥���e>�٥���n^!³�_&�2��]ȳ�	y�آEE7&��U,p�f|���ς�\e�Ouq1Vo!o�#m�ey��#�nI]*��o!�?���y���-��G�%����A�<;|�|��0*��ʶ��x���7�+�Rx��1� %� d-�uFVE�0�Gdz�|��<+�S�?qN'p���J_����gqhY�(���2����>�?�C�^�E�eV������.��� �Ș_����0*���!�����^�h��^p�����Q�'AVm��wr��z��!���_v���;��Hw�a2�J҃ci"���q�!�w �i��=.gD�	����sdl����~�����������FU�kr~t�z� ��OW�=�[�g��"�[����E�U��Ui����8�Ѯ���j�����zz���,�.ِ���~x4.���6��Bz��GKZ�q���6b`�`m�OX�eq@�L btE�.T�e���4��@hgXＱIàe1�:�uA���\:	y#�wGSMKg�A`�S�
�_���՜���/��Wh5��Y-L|H8�4�?����w�п Μ����Egz�c�����[[�>�@P�*�2������Y����j�Y �@�X+�E�OZQ=�zUX��UX���ŶB�dG�KF���X[�Y��2����ڥ!t��|E���D���!ˀ��6`��e2.<���In%�m���Ö:���`qd�(p��բv�Wr9�|��B���?V6g}a{��u]�a�a�;��k�#���U �v]l*t�뒟% �<��	^ ��t�z�X��c�z:t�%> ����B�4XZ�z�.�dp��!��}�S,��̡̍��l�	�l�P8�@R��/O�pq��eW׀��5�^D����l����eu�.6����'JZ�J�D� �uep�mc[J� �T��(��Ap�`�8�$��Tro_@�����I�f_ưJ�@���\�1��>�K��d�N�&�@�mo˽�'��6�nw�)F�9ư�+ �
�1�)� �A{䢶�
��MP��?9	�z�� �Y0����X]��`m�3 	�^U�X�(�<(�e��ف4W����j��d`�g}���M�;�� d��ݴ�yj�v�,�0�I���}��n��G�����@ 땉*iְ�UW{�qNV�NñhP`���C�\l����{�����ǖ�7n�Kq�b�m�W�վ�"D�[�j1����Jֺm[͇7�Մ�8<uf��ɉ�ef2��`uXSuH�0O�i��5��cVǕ��(�������~82�m��1����s�b�JR�/�9������hwH[h�Ά�P�NPp����:����C�0G��#7�-�.7ԀO��GH>Źu��!?޵#|Y���5|_�?7>��qseW��'#�f�O2���H`�!C|B|� �Ԗm�숹a�JL���@f߆gu�:A3E>~��@d�g�b�Н�94��`�+V�"�-K[U��,��e��ǳ��F�]�z�O��٧c劆N���ڑB��!�j��$#1B�Ȑ"��n��6.Gڸ$͐�����f;FI�pT�J:��� j�w��1��b�Y�ϜX>�U�>i?��m��XO���!�Ŏ�&̮��,nV%��)5�M,�"�$�naRL�$�
ǔ��JHj� ���f2S��(I�&&��i��9�?�f���	���e��t=Eo�wnI��uG�,���̾'�������;���x��1x!��,W��:�e�"�9����e��Jsڹ8_�,ͲE�Tz�A�
�07��ėNL��g�������=�����%�������g�㱫r�HW[]�c�����*���vdg28�AGc����OZhG5��&����ZgZ�A�F[F{߸��m��&Sw�ֲ������C0ۭnΐ������~�a��$���Bz�� �$�M��9��A��}<E��x�]�y��rr=kE8�l>�g�gӡ:?AQܳFg��L��m�T��',	?�(���#^��.�Mx���76?���r%1��&��Y����`���Fg�K�덮��} ���zjמ���6π{̲Z�MZeK"-r�O�i�.q�� �)�\�?�+�S,���˝ 7b*��_(�z~[<=
�<qfޙ|֖4]�����E��`б���#��u��;�_C���Yt7�����u�e�Џ�n�_��ee�e�l�ap�Q���!	 �\�ح��|���]!yw�8���G,sV.f�&6�B�@GEg��7�:��������M��⿄I,r����t�����m�x�C��N�酯��������~X�}�W��7�o�������^>��ޒn6����������T� ���^�O�ئ�'#���Gڗ��?/�$p���M����|�����@����%<�<�<мP4���7J���G��u�����e�)rL�v�m�b�HT�-��1���-E�Z�Ho)T��C�	5#���dR�LY���N���?D����!��^�����y��f���u8���4u�W��9��w�i.���J~^�q��SI�zN��\SD�\�>#��Bd��d���i5ZV{x�-q#$-��V?~:)��I�R�t�T��bʬ&��xw�j�ű?����O���?���_z���Ɔ��8iw����������H���'�������Gڗ�� x���ʧ��?�����[�d$r���H�,�R����+��� ��]��������
�x ��D�O����.�Ij[�S����j��G�Jti_��2�g����?:|��G:��<��<�����p�)����y��?{�֝(�m����1Z=��"�"���= Q��MbUw�;�T�ʚO)+������Zk~����w���P�m�W����?��KB���C+@�
����!���U���?X����^��vcw�N@eK;��?�J�?}MHn���u������c���>��y]�D>������Y%D>}l��������ĮVYC)��YX�z�E���d����v�f*V���bKi����o���x�i�<dQ�Z��Ķ�1hm����}{�������g���[&�����u�k��R�"!飡L�so�Y���۽O�[6c{���j{�ı1U4��M�aJ��̗���;��ҞľM��ql��!�ް�1�h�گv����s�ef�w3j����_j���D��P�m�W���e��CJT٨E�� �	��K�?A��?A�S�������+5�Y��U���k�Z���{��O���Z���o���Q�����Û��֥������	���t��i\U�8�vb����V�����u�KY�;��Y���G���;e���O���P��p���p���R-�B{D�V���׌��ɞ"(a��'��mgL���T�y)��͐�uMΞ�z�u}�k|�T���;����\�/�ȕ��K������7/?ph(^%#�S��Jp�u\vW4�	�$�L+m����f[Aۨ�G|�:t~8sMRF�劉7j(9��f
'��KF�h�O������������+5�����] ����k�:�?������RP'���=���6�Q�Q,�,�R�h@z���>��M�4��磄O���pF�����(���r�+������S$$�f���H�d�qWp�t�s�w�-m������o��������ɋÈr8Y��bz�Ĵ�L=g������$����l�Haʑ$ٽ:8��K�!����𤸳���u��C�gu�������[)�p����:Ԃ�a��2Ԁ����2������_u����A7d�ʍ�f2�����S��W���o����)3Ȓí��{ݗGb8hF���3�˥z��Es��s3�E���*D�aF��D�Gf��Bg~hX�x��y�Ɔ̣*ٴ<���ｨ����"���������7��_��U`���`������W���
�B�1̝�#p�e�-�������!�o����w�09�Oӻ��ٲ��������[�a�\���g� @���3 �?�هg \�������T��! o���yBm�o6z��P�d��Е��#�F�)��\�6KӔ�m���F�G=F����Pz����x�9�ތݒ����2t�	ま�/O����|�� ��rM��;!�[�E|"���q��4�p���H�<+��n k$TXV��	��餭f�>o �Bbk#��D�_j\D���7ܟ4��l��<RQuwH[Mvv��ИNՎEӹ��6HBϷ��f�~���e�53�[g���x�N�9�o�1��'Aǚ�����9_�E�:�?�|��H�e������E����z?�A1���:�?�>����)(��!ӯ�(��0��i������C�?��C���O��W�R�ƹM���$�23w���.�.M�\��,���ͮ�A���X. � si7���OC��G�(�J����u��aU(�MM���*��шO���};"Z��Ġ���_s(y�4�g�,ȥ�l������ȇ�fM�4Z�I���_��#�m2yNͶq�7މ鴬]%�-��}/�p�������S
>���U?K�ߡ�����&0���@-�����a��$����lA�{��_5�_�:��U�����~���	����'h����������/~�����Ho�gM�}N&L�ȫظ����J�%޽�˸�@~f����3���V6��y>6�ý;��ǝj�Aޜ�nX�$X{u2-m��>���xI�ii���VW�lz�񈉇�|ꪼ�rgfQ�0N�K�n2J��C�!�s;�եe	=�'�ȵ�+=g�_�m'��1�-�w�{`E��ݰ����6]������[��]�C���~*;�5�C$3ՠQ��5H�-8j�5��H
�������8k�JhR*����y��9ue%�8�`"����htI�9�t{��z,�4�A�]���[��p�{]����u�# ��"���0^7ԡ�0�M��W
`��a�濡������>���%����������P:�?}	.@]P���A�/AB�_ ��!�����?��FA���Ͽ�����y����������ԁ�q���	��2P�?���B� ��������P1�C8D� ���������KA��!*�?���O=8��?JA���!�FY����$�?������W�p�j���;��?JB�l�T�������Sw���%�F�k!������J�?@��?@���A�U�� �B@����_-�����^��e������J�?@��?@�C���������/�B��
P�m�W�~o������RP+�����Q���������?����K��B-��@�a���@��*8g�d@�_�������O�z/���N��a1�C{s�gXe�,�}�c}�ĉ�B4;sQ� Q��X��<�q]�%I��_�Y���u��Ơ����Cet������[���\*N��*P�����0�E����$jr�ʣ�ϏP�z{�Ǹ%~1T�~Xy]����(f��S�^-Wdň\�q���!G+�l�3Պ�u�v����N��������d�=�c��:�E���K��'U�^3�����ա���>��o������P�����P���\���_�/�:�?���W��ШSc߷�Vc��Ⱦћbg9����_���i�Sy��V�ڛ3֋&�oX�n�PfQ|���d�"�!u�08a���m�Ӄ���b1MOm~;�jҠO�i3�QBU�v�,dJ��ｨ�����w�KB�������_��0��_���`���`�����?��@-����������xK����������MF�8w�Ɯ���
�Q������j������N�ic��z���d�i�ޭR�o6���Ҥٙ�^�v0�I�v)�l�M���{�F�9V�a�.�%_{n;'2]?G��Nɂ�-Wϴv�#��n���׌��K'^���%�py/�Pn	����5��e�>��f�}	��b�~��b*,��>a�3����~Y��5��s��-'i�3�y��GD�Lٻ��Y�z'gn\��[9*	�p2#��s���xߘq<��igB5�ÖX5盔b���]����d7v�o�Ǐ�Q��o)�����������p��@�?�|��	�ߥ�?�O�n0�U[�q���Ic���@�G���/	�_����\O��������`^�$�S������?�E~v�����ǵ�n&s�0N��.��u�rO���-�7o�"��Y���g�M���[�4F>z��Ο,?��~�,?��g�r�������KWu9�Z�W��Z��9�dl��/N�"|w]5AȯufwC��WŴ�ѱ9��������6�Je1��c�=:����\4�sc�3�z��=L�c�NF�6��!l��%�O,��ܢe���'�͝�ڹ���B8��_�?��~��7[���NS��3)4"A�7��DC0��"wl�mr#���j,��K;d�Z�z�2�z����|ыLV�B�K��Q�јw,~2�N��F��,1�
��t��<Mу��rM�O{�@�)���r̙})�˿��wC-�u7��ߒP��c<
�h�p=f�b$�rs�����$�ss��Q���}�$��K0�S>x����`���P���~����`�������|���A�����l7y���<ݓG(e>������˕?��#r�V`����������@���H���@������RP����������G���Ѡ�J�[�_����w�OٳǾ�E�@�u�N��ܿ��\�\���[/urN=yW������6����w���wxM�o�_����l?�}��AD{�c��0Z��)���p������U�i��с���ŵ�Y���'��3v>.&�V7���;��~�G}���<��\O.֑�7È���8j0��m'[^	Ogi�2�ŘW���W�ǾM��j0i{������Z��!W���D	Q�k�ze�>�^~�����i�5�&X�q�p���XYvɦ�h��ܝf���}����G�?��[
J��S.�~@�,�sǯ?��|E1A0�<��\�e����]0c1
wq��<����'���������������_�C��6h-��r��i��9�v���}�7N��w����e�U� �-��������~��c��2P�wQ{���W������_8᱖ �����!��:����1��������w�?�C�_
����������ƴ�T{mh�^Of{�,<,����/��5A��?�^���*����Gi�/n!
ȷ�@N$K&4iz֗�Y�Vg=N.�)ϏI��GK�w�\!m]�:W��ѕK~����d��������;�'5�m���_��I�:�<�<䡧Nn�"ؾ�޺��@@Q����v'��L:3i6ק*i�A�-|�Z{��vW~]	/�e���Z<-�Q�k�hok��C����`��*]�훭��;ݡo�O�U���ރ���fV�XN�v����i�"f-��O��V�^)�e
M!>��X=��(5!n��}��ԍO�ǛC���n�Q�Z����֮��ۆ-)M��hq�UF�$�͋R]�䀽���ڮaLJS��L�>^�s�������EK�7�v֬���@p�2`Jr]�VR�Q��`�1����Z�$E���z%��3�o����������?��E�oh�����o��˃���O��R�!4������䋐��	�	��	�0���[���9�0�K���m�/�����X��\�ȅ�Q�-�������ߠ�����`��E�^��U�E�����	�6�B�����P�3#������r�?�?z���㿙�J��qA���������������2��C]����#����/��D��."�������P�!������K.�?���/�dJ��B���m�����E���Ȉ<�?d��#��E��D���C&@��� ����������u!���m�����GFN��B "��E��D�a�?�����P������0��	(��б!�1��߶���g�����Lȇ�C�?*r��C�?2 ���!��vɅ�Gr0������<��������۶���E�����2"�op4E��^��f����U�Mư��U,��ɗL�`8ò���la�,�|�#9�c�V��OO���]����/��NO%nިN���.�U�)6e��M���.K���Ze2�ұ�n�����N�"Yяi����m�A�e�B;b��ўl7�EOH��M�j�h��N�� n�����ڡ�P�̹֒ʐ{��i��_�zs��صj�Q�(�������`�$�4ڃ�����߻�(��3���C�Ot����5���<�����#��?�@����O�@ԭp��A���CǏ��D�n�����cb"�X�7
q�0�qܲ���-񻨶������ר�V�y�=Xmt#�z䶶�P������G8گ���~��[��Al�p�jb�]#y5�.ձ����ăj�BO����/��/"P���vo?c����E��!� �� ����C4�6 Bra��܅��� �/�Y����k���-;
j~h{Z�*��*�y����j�n�}>ŊXg2��+�+;P�}=؆�mHE�^o�eI�m�g�q��������mݝ��Hƅ��[>$�9v*x~91ɼ�d�i�Z��6���/j]mW)��C�a���^�M�9[g�p����a^E�?�r�a��5فhWkbר<�)�SQ����^m��9�@��/��onVՊ�د��^�|��OIl���TJ8�Z�6p)�+���*��.��T�B�p�i)�J�R+aBr]|��7KC�h�]�8.n2���M�~z��%y��(�?����� �#�d��k����A!�#r�����/�?2���/k�A������O��?˳��Y�T��$0�p����#��J���dr��8궸E@�A���?s%��3!O�U �'+��������o����P��vɅ�G]��/���$R���m�/��? #7��?"!�?w��KA�G&|3���h��?���oBG��c���&��2.�?�A��F\�>���c�G�X������c�G�a؟��HS?�W��N���9������<���.�[t�~�+��Z��q�*~Ǭ-�X��0�}c^�P���T�i��l���i,N�6�i��G�#�%k|�lj��(�:J�~�?������]�����i�a;�ВҨ��&{[A��ʴ��cA��NB���+8��Ld�,��͈"�gV��$mm�Չn�Yck$Gm���O�݊E�5��,����XY�a(�u��
�X�΀A.�?��Gr���"��������\�?��##O���F2%����_��g����_P�������Ar���"ਛ�&�����\�?K��#"G�e xkr��C�?2���W*i������v�5�H8�\�-{М���������X���'Z{c�[���9M��r ��_>� ���V���64z�()� 8�S�Y�o���6mћ���fH`J��JT�O�ޢY-ڨ�E.no���,+�È�� ,M�39 X��{9 �X�{�b��¢\��.��J��/L�sUl��G!]X����m�ɲޕ�˛����ȤV�kJgi�8�M��
�5���X_�?���Ʌ�G]Y��er���"�[�6�����<���R����������V�-���\��y��i�%u��)��h�,�M�2,R�I�bS�9�\��9�}�����Ƀ�_[�����G��9�g|�aܒ�0���	��i@�4j9���ɬ�V�U͜F�������ћ�Dco?ЪAl�����z��+V��]Դ�~?W�Sɡ�Ӱ�F�A����:1�'U�
.q��rٍ&���k�C��?с��O�B� 7N���Б���d ���E 7uS�$y�����#�?�[�˚ޑU���X�X1�x)��~�!������؉��g���KGv;li��+L�a�2kB���Ƙ���د��	Y�z��c�=����Q[����Y{����К\��������by��,@��, ��\�A�2 �� ��`��?��?`�!����Cķ�qj���g��aa����w,�.��q4ܒ�EH�_��{��������x�PX��N[W�h�i݂��~A���?�w�n�5sTnQ��T�VD�X�J|t��$,6ŶZ(��=4?T�:U�Z۶�^J�������v��	q��d牏ת4�(v�u!N�CY�kbܔ����%��D'�O�Æ_*�n4��RU�t�@�-���c�]E$cL=��'J�Yx� �iV���6�KCz��?m[~���
�4�zu�y=�n�|ِ��|r�S�p\۳c�X^������H�1X�F9zXp{j��6F�����ݝ�L�*N��_�`�n�_xq��;g=���볿��$��_�?ͤ���g��;�MO������S���������mE=�^�5A�)�G�&������q;������g9k�����T���	���v���ĵg���O�ם}�~��~���Bs]s�|()0������������?�V*��槿��}c^���OIT{�r.��3�1�Gq�W�4ͧ����=�/Bw\B�������\�r�0�� ���~��������yx��f�ߙ��=32�ds�9�]`bBO�����6��l��Y4�&n��L�7w�do/8b�������O$����/�Я췇=���������w������<y�{|�/�~}��i���>��'*�
�y~g]�O|���q�N��?�0;���WkI�Z^�׏��͹m��q�#|����В�{ֹ�C<^$��\�qm|��[��;�'���Ŀ��@�>�f�=|��Z�Orw��3������ھ�b��4��ܚ��Y`�_�d��99��}��{/���N�㟟�Ǎ�!�<��x��x�%��Z���&�� ��x���|z��縿uJI�����/��.��v���S��>6��ݪ)�c'wqi�.LE�v�ן����U�LO�N��ҟ���>��'��o��                           .�C��M � 