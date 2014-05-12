echo "Stopping Katon daemon"
katon stop > /dev/null
echo "Removing ~/.katon"
rm -rf ~/.katon
echo ""
echo "Done"
echo ""