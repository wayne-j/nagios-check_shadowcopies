# nagios-check_shadowcopies
nagios wmic script to confirm basic status of a shadow copy configuration.

Requires wmic-client in order to function.

Built to suit our needs, using basic nagios practices it's somewhat customizable.

./check_shadowcopies [Hostname] [domain/username] [password] [Min amount of desired copies in MB] [Min count of copies]

Where:<br>
  <ul>User; is a WMI permissioned user for the hostmachine.<br></ul>
  <ul>Min amount of desired copies; adds all shadow copy volumes to WARN if less files than expected are shadowed.<br></ul>
  <ul>Min count of copies; the default number of copies windows stores is 64 per volume.  Critical if less than expected.<br></ul>

Outputs Performance data - graphs size of shadow copies over time.
