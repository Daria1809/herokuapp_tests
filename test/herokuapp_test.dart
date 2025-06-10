import 'package:webdriver/async_io.dart';

Future<void> main() async {
  final driver = await createDriver(
    uri: Uri.parse('http://localhost:4444/wd/hub/'),
    desired: {
      'browserName': 'chrome',
    },
  );

  try {
    // 1. Form Authentication
    await driver.get('https://the-internet.herokuapp.com/login');

    final usernameInput = await driver.findElement(const By.id('username'));
    await usernameInput.sendKeys('tomsmith');

    final passwordInput = await driver.findElement(const By.id('password'));
    await passwordInput.sendKeys('SuperSecretPassword!');

    final submitButton = await driver.findElement(const By.cssSelector('button[type="submit"]'));
    await submitButton.click();

    final flashElement = await driver.findElement(const By.id('flash'));
    final message = await flashElement.text;

    print('Login Message: $message');

    // 2. Checkboxes
    await driver.get('https://the-internet.herokuapp.com/checkboxes');
    var checkboxesStream = await driver.findElements(const By.cssSelector('input[type="checkbox"]'));
    var checkboxes = await checkboxesStream.toList();  // Превращаем Stream в List
    await checkboxes[0].click();
    final isSelected = await checkboxes[0].selected;
    print('Checkbox 1 selected: $isSelected');

    // 3. Dropdown
    await driver.get('https://the-internet.herokuapp.com/dropdown');
    final dropdown = await driver.findElement(const By.id('dropdown'));
    await dropdown.sendKeys('Option 2');
    print('Dropdown selected Option 2');

    // 4. Hovers
    await driver.get('https://the-internet.herokuapp.com/hovers');
    // Hovering isn't supported directly; пропустим

    // 5. Inputs
    await driver.get('https://the-internet.herokuapp.com/inputs');
    final input = await driver.findElement(const By.tagName('input'));
    await input.sendKeys('123');
    print('Typed 123 in input field');

    // 6. Add/Remove Elements
    await driver.get('https://the-internet.herokuapp.com/add_remove_elements/');
    final addButton = await driver.findElement(const By.xpath('//button[text()="Add Element"]'));
    await addButton.click();

    final addedElement = await driver.findElement(const By.className('added-manually'));
    await addedElement.click();

    print('Added and removed element successfully');

    // 7. Notification Messages
    await driver.get('https://the-internet.herokuapp.com/notification_message_rendered');
    final clickHereLink = await driver.findElement(const By.linkText('Click here'));
    await clickHereLink.click();

    final notifElement = await driver.findElement(const By.id('flash'));
    final notif = await notifElement.text;
    print('Notification: $notif');

    // 8. Redirect Link
    await driver.get('https://the-internet.herokuapp.com/redirector');
    final redirectButton = await driver.findElement(const By.id('redirect'));
    await redirectButton.click();

    final redirectedUrl = await driver.currentUrl;
    print('Redirected to: $redirectedUrl');

    // 9. Status Codes
    await driver.get('https://the-internet.herokuapp.com/status_codes');
    final status404Link = await driver.findElement(const By.linkText('404'));
    await status404Link.click();

    final statusPage = await driver.pageSource;
    print('Status page contains 404: ${statusPage.contains("404")}');

    // 10. File Upload
    await driver.get('https://the-internet.herokuapp.com/upload');
    final uploadInput = await driver.findElement(const By.id('file-upload'));

    // TODO: Укажи корректный абсолютный путь к файлу на твоей машине
    await uploadInput.sendKeys('/path/to/your/file.txt');

    final uploadButton = await driver.findElement(const By.id('file-submit'));
    await uploadButton.click();

    final uploadedTextElement = await driver.findElement(const By.tagName('h3'));
    final uploadedText = await uploadedTextElement.text;
    print('Uploaded File: $uploadedText');
  } finally {
    await driver.quit();
  }
}
