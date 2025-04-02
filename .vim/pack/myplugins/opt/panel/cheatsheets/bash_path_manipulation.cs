p=/usr/local/share/awk/assert.awk

dirname  ${p}                       # => /usr/local/share/awk
basename ${p}                       # => assert.awk
basename ${p} awk                   # => assert.
basename ${p} .awk                  # => assert

echo ${p%/*}                        # => /usr/local/share/awk
echo ${p%.*}                        # => /usr/local/share/awk/assert
echo ${p##*/}                       # => assert.awk
echo ${p##*.}                       # => awk

echo $(expr "${p}" : '\(.*\)\.')    # => /usr/local/share/awk/assert
echo $(expr "${p}" : '\(.*\.\)')    # => /usr/local/share/awk/assert.
echo $(expr "${p}" : '\(.*\)/')     # => /usr/local/share/awk
echo $(expr "${p}" : '\(.*/\)')     # => /usr/local/share/awk/
echo $(expr "${p}" : '.*/\(.*\)')   # => assert.awk
echo $(expr "${p}" : '.*/\(.*\)\.') # => assert
echo $(expr "${p}" : '.*\.\(.*\)')  # => awk

# vim: ft=shell fdm=marker fmr=<<<,>>>
