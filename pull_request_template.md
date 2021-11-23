## GoGoal Project Pull Request Review Checklist

Please self-check and peer-review all the following items before merging to main branch.

- System setting
  - [ ] If you changed the `DEVELOPMENT_TEAM` in the `project.pbxproj` file, it's fine.
  - [ ] But make sure you did not change the `PRODUCT_BUNDLE_IDENTIFIER`.
  - [ ] Switch back `Environment` to `DEV` in the `Info.plist` if you had changed it to `PROD` in your local test.
- App functionality
  - [ ] Confirmed by your testing, the existing functionalities are not affected.
  - [ ] Confirmed by your testing, the new features (if any) are working as expected.
- Frontend UI
  - [ ] The new UI components look clean and easy to understand.
  - [ ] The colors and font sizes are suitable on common devices (e.g. dark mode compatible).
  - [ ] The static picture resources are put correctly under the `Assets.xcassets` folder.
- Coding convention
  - [ ] Spacing
  - [ ] Indentation
  - [ ] New line

If all of the above items are checked off, you are ready to go!

