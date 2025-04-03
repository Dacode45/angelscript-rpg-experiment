class AWarriorHeroCharacter : AWarriorBaseCharacter
{
	UPROPERTY(DefaultComponent, Category = "Camera")
	USpringArmComponent CameraBoom;

	UPROPERTY(DefaultComponent, Category = "Camera", Attach = CameraBoom, AttachSocket = USpringArmComponent::Socket)
	UCameraComponent FollowCamera;

	UPROPERTY(EditDefaultsOnly, Category = "Character Data")
	UDataAsset_InputConfig InputConfigDataAsset;

	UPROPERTY(DefaultComponent, VisibleDefaultsOnly, BlueprintReadOnly, Category = "Combat")
	UHeroCombatComponent CombatComponent;

	default CameraBoom.TargetArmLength = 200.0f;
	default CameraBoom.SocketOffset = FVector(0.f, 55.f, 65.f);
	default CameraBoom.bUsePawnControlRotation = true;

	default FollowCamera.bUsePawnControlRotation = false;

	default CharacterMovement.bOrientRotationToMovement = true;
	default CharacterMovement.RotationRate = FRotator(0.f, 500.f, 0.f);
	default CharacterMovement.MaxWalkSpeed = 400.f;
	default CharacterMovement.BrakingDecelerationWalking = 2000.f;

	UFUNCTION(BlueprintOverride)
	void ConstructionScript()
	{
		FollowCamera.AttachToComponent(CameraBoom);

		CapsuleComponent.SetCapsuleSize(42.f, 96.f);
	}

	UFUNCTION()
	void OnStartupDataLoaded(UObject LoadedObject) {
		auto startupdata = Cast<UDataAsset_StartupDataBase>(LoadedObject);
		startupdata.GiveToAbilitySystemComponent(WarriorAbilitySystemComponent);
	}

	UFUNCTION(BlueprintOverride)
	void Possessed(AController NewController)
	{
		Super::Possessed(NewController);

		if (!CharacterStartupData.IsNull())
		{
			CharacterStartupData.LoadAsync(FOnSoftObjectLoaded(this, n"OnStartupDataLoaded"));
		}
		else
		{
			OnStartupDataLoaded(CharacterStartupData.Get());
		}
	}

	// UFUNCTION(BlueprintOverride)
	void SetupPlayerInputComponent(UInputComponent PlayerInputComponent)
	{
		check(InputConfigDataAsset != nullptr);
		check(PlayerInputComponent != nullptr);

		ULocalPlayer LocalPlayer = (Cast<APlayerController>(GetController())).GetLocalPlayer();

		UEnhancedInputLocalPlayerSubsystem Subsystem = UEnhancedInputLocalPlayerSubsystem::Get(LocalPlayer);
		check(Subsystem != nullptr);

		Subsystem.AddMappingContext(InputConfigDataAsset.DefaultMappingContext, 0, FModifyContextOptions());

		UWarriorInputComponent WarriorInputComponent = Cast<UWarriorInputComponent>(PlayerInputComponent);
		check(WarriorInputComponent != nullptr);

		WarriorInputComponent.BindNativeInputAction(
			InputConfigDataAsset,
			GameplayTags::InputTag_Move,
			ETriggerEvent::Triggered,
			FEnhancedInputActionHandlerDynamicSignature(this, n"Input_Move"));

		WarriorInputComponent.BindNativeInputAction(
			InputConfigDataAsset,
			GameplayTags::InputTag_Look,
			ETriggerEvent::Triggered,
			FEnhancedInputActionHandlerDynamicSignature(this, n"Input_Look"));

		WarriorInputComponent.BindAbilityInputAction(
			InputConfigDataAsset,
			FEnhancedInputActionHandlerDynamicSignature(this, n"Input_AbilityInputPressed"),
			FEnhancedInputActionHandlerDynamicSignature(this, n"Input_AbilityInputReleased"));
	}

	UFUNCTION()
	void Input_Move(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction) {
		const FVector2D MovementVector = ActionValue.Axis2D;
		const FRotator MovementRotation(0.f, Controller.GetControlRotation().Yaw, 0.f);

		if (MovementVector.Y != 0.f)
		{
			const FVector ForwardDirection = MovementRotation.RotateVector(FVector::ForwardVector);
			AddMovementInput(ForwardDirection, MovementVector.Y);
		}

		if (MovementVector.X != 0.f)
		{
			const FVector RightDirection = MovementRotation.RotateVector(FVector::RightVector);
			AddMovementInput(RightDirection, MovementVector.X);
		}
	}
	UFUNCTION()
	void Input_Look(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction) {
		const FVector2D LookDirection = ActionValue.Axis2D;

		if (LookDirection.X != 0.f)
		{
			AddControllerYawInput(LookDirection.X);
		}

		if (LookDirection.Y != 0.f)
		{
			AddControllerPitchInput(LookDirection.Y);
		}
	}

	UFUNCTION()
	void Input_AbilityInputPressed(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction) {
		UInputActionWithTag SourceActionWithTag = Cast<UInputActionWithTag>(SourceAction);

		WarriorAbilitySystemComponent.OnAbilityInputPressed(SourceActionWithTag.InputTag);
	}

	UFUNCTION()
	void Input_AbilityInputReleased(FInputActionValue ActionValue, float32 ElapsedTime, float32 TriggeredTime, UInputAction SourceAction) {
		UInputActionWithTag SourceActionWithTag = Cast<UInputActionWithTag>(SourceAction);

		WarriorAbilitySystemComponent.OnAbilityInputReleased(SourceActionWithTag.InputTag);
	}
}