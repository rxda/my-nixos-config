{ self, ... }: {

  system.configurationRevision = self.rev or self.dirtyRev or "unknown";
}
