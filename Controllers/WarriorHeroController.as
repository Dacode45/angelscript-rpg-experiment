class AWarriorHeroController : APlayerController
{
	UWarriorInputComponent InputComponent;

	UFUNCTION(BlueprintOverride)
	void BeginPlay()
	{
		// Joe Look Here for how I set up input
		InputComponent = UWarriorInputComponent::Create(this);
		PushInputComponent(InputComponent);

		auto actor = GetControlledPawn();

		AWarriorHeroCharacter character = Cast<AWarriorHeroCharacter>(actor);

		character.SetupPlayerInputComponent(InputComponent);
	}
}