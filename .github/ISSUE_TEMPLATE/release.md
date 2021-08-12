---
name: Release Template
about: Verify code is ready to release
title: ''
labels: Release
assignees: ''

---

This checklist is for verifying the release is ready to publish and published correctly.

## Release Summary

- dapr-k3d
- vx.x.x

### Validation

- [ ] All packages up to date (or task created)
- [ ] Remove any unused flags or conditional compilation
- [ ] Remove unused packages
- [ ] Code changes checked into main
- [ ] Code Version updated
- [ ] Code Review completed
- [ ] All existing automated tests pass successfully, new tests added as needed
- [ ] Existing documentation is updated
- [ ] New documentation needed to support the change is created
- [ ] CI completes successfully
- [ ] CD completes successfully
- [ ] Smoke test deployed for 48 hours
- [ ] Reviewed & updated readme for Developer Experience
- [ ] Resolve to-do from code
- [ ] Verify all new libraries and dependencies are customer approved
- [ ] Run cred scan
- [ ] Validate e2e testing

### Release

- [ ] Tag repo with version tag
- [ ] Ensure CI-CD runs correctly
- [ ] Close Release Task
